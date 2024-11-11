extends State
 
var characterBody : CharacterBody3D
@export var animationTreeLegs : AnimationTree

@onready var slideTimer : Timer = $SlideTimer
var sliding : bool

const MAX_VELOCITY_GROUND = 12.0
const MAX_ACCELERATION = 10 * MAX_VELOCITY_GROUND
const GRAVITY = 15.34
const STOP_SPEED = 1.5
const JUMP_IMPULSE = sqrt(2 * GRAVITY * 0.85)

var friction = 2

var direction = Vector3()
var wish_jump : bool

func enter(host) -> void:
	characterBody = host
	sliding = true
	direction = Vector3()
	direction -= characterBody.transform.basis.z
	
	animationTreeLegs["parameters/conditions/is_sliding"] = true
	animationTreeLegs["parameters/conditions/not_sliding"] = false
	
	slideTimer.start()

func exit(host):
	animationTreeLegs["parameters/conditions/is_sliding"] = false
	animationTreeLegs["parameters/conditions/not_sliding"] = true

func physics_process(host, delta):
	
	process_movement(delta)
	
	wish_jump = Input.is_action_just_pressed("Jump")
	
	if characterBody.is_on_floor() and sliding:
		return str(name)
	elif characterBody.is_on_floor() and !sliding:
		return str("On_Ground")
	else:
		return str("In_Air")

func process_movement(delta):
	# Get the normalized input direction so that we don't move faster on diagonals
	
	var wish_dir = direction.normalized()
	
	if characterBody.is_on_floor():
		# If wish_jump is true then we won't apply any friction and allow the 
		# player to jump instantly, this gives us a single frame where we can 
		# perfectly bunny hop
		if wish_jump:
			characterBody.velocity.y = JUMP_IMPULSE
			
			wish_jump = false
		else:
			characterBody.velocity = update_velocity_ground(wish_dir, delta)
	
	# Move the player once velocity has been calculated
	characterBody.move_and_slide()

func accelerate(wish_dir: Vector3, max_velocity: float, delta):
	# Get our current speed as a projection of velocity onto the wish_dir
	var current_speed = characterBody.velocity.dot(wish_dir)
	# How much we accelerate is the difference between the max speed and the current speed
	# clamped to be between 0 and MAX_ACCELERATION which is intended to stop you from going too fast
	var add_speed = clamp(max_velocity - current_speed, 0, MAX_ACCELERATION * delta)
	
	return characterBody.velocity + add_speed * wish_dir

func update_velocity_ground(wish_dir : Vector3, delta):
	# Apply friction when on the ground and then accelerate
	var speed = characterBody.velocity.length()
	
	if speed != 0:
		var control = max(STOP_SPEED, speed)
		var drop = control * friction * delta
		
		# Scale the velocity based on friction
		characterBody.velocity *= max(speed - drop, 0) / speed
	
	return accelerate(wish_dir, MAX_VELOCITY_GROUND, delta)


func _on_slide_timer_timeout() -> void:
	print("Slide timer timeout")
	sliding = false
