class_name PlayerController
extends CharacterBody3D

#movement constants
const MAX_VELOCITY_AIR = 0.6
const MAX_VELOCITY_GROUND = 6.0
const MAX_ACCELERATION = 10 * MAX_VELOCITY_GROUND
const GRAVITY = 15.34
const STOP_SPEED = 1.5
const JUMP_IMPULSE = sqrt(2 * GRAVITY * 0.85)

var friction = 4

@export var mouse_sens : float = 0.05

@onready var camera = $Camera3D

var direction = Vector3()
var wish_jump : bool

func _ready() -> void:
	
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	

func _physics_process(delta):
	
	if Input.is_action_just_pressed("Escape"):
		get_tree().quit()
	
	process_input()
	process_movement(delta)
	

func _input(event: InputEvent):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sens))
		camera.rotate_x(deg_to_rad(-event.relative.y * mouse_sens))
		camera.rotation.x = clampf(camera.rotation.x, -deg_to_rad(60), deg_to_rad(90))

func process_input():
	direction = Vector3()
	
	if Input.is_action_pressed("Foward"):
		direction -= transform.basis.z
	if Input.is_action_pressed("Backward"):
		direction += transform.basis.z
	if Input.is_action_pressed("Left"):
		direction -= transform.basis.x
	if Input.is_action_pressed("Right"):
		direction += transform.basis.x
	
	wish_jump = Input.is_action_just_pressed("Jump")

func process_movement(delta):
	# Get the normalized input direction so that we don't move faster on diagonals
	var wish_dir = direction.normalized()
	
	if is_on_floor():
		# If wish_jump is true then we won't apply any friction and allow the 
		# player to jump instantly, this gives us a single frame where we can 
		# perfectly bunny hop
		if wish_jump:
			velocity.y = JUMP_IMPULSE
			# Update velocity as if we are in the air
			velocity = update_velocity_air(wish_dir, delta)
			wish_jump = false
		else:
			velocity = update_velocity_ground(wish_dir, delta)
	else:
		# Only apply gravity while in the air
		velocity.y -= GRAVITY * delta
		velocity = update_velocity_air(wish_dir, delta)
	
	# Move the player once velocity has been calculated
	move_and_slide()

func accelerate(wish_dir: Vector3, max_velocity: float, delta):
	# Get our current speed as a projection of velocity onto the wish_dir
	var current_speed = velocity.dot(wish_dir)
	# How much we accelerate is the difference between the max speed and the current speed
	# clamped to be between 0 and MAX_ACCELERATION which is intended to stop you from going too fast
	var add_speed = clamp(max_velocity - current_speed, 0, MAX_ACCELERATION * delta)
	
	return velocity + add_speed * wish_dir

func update_velocity_ground(wish_dir : Vector3, delta):
	# Apply friction when on the ground and then accelerate
	var speed = velocity.length()
	
	if speed != 0:
		var control = max(STOP_SPEED, speed)
		var drop = control * friction * delta
		
		# Scale the velocity based on friction
		velocity *= max(speed - drop, 0) / speed
	
	return accelerate(wish_dir, MAX_VELOCITY_GROUND, delta)

func update_velocity_air(wish_dir : Vector3, delta):
	# Do not apply any friction
	return accelerate(wish_dir, MAX_VELOCITY_AIR, delta)



# Add a debug sphere at global location.
func draw_debug_sphere(location, size):
	# Will usually work, but you might need to adjust this.
	var scene_root = get_tree().root.get_children()[0]
	# Create sphere with low detail of size.
	var sphere = SphereMesh.new()
	sphere.radial_segments = 4
	sphere.rings = 4
	sphere.radius = size
	sphere.height = size * 2
	# Bright red material (unshaded).
	var material = StandardMaterial3D.new()
	material.albedo_color = Color(1, 0, 0)
	material.flags_unshaded = true
	sphere.surface_set_material(0, material)
	
	# Add to meshinstance in the right place.
	var node = MeshInstance3D.new()
	node.mesh = sphere
	node.global_transform.origin = location
	scene_root.add_child(node)
