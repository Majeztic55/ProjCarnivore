extends State

class_name In_Air_State

var characterBody : CharacterBody3D

const MAX_VELOCITY_AIR = 0.6
const MAX_VELOCITY_GROUND = 6.0
const MAX_ACCELERATION = 10 * MAX_VELOCITY_GROUND
const GRAVITY = 15.34
const STOP_SPEED = 1.5

var friction = 4

var direction = Vector3()

func enter(host):
	characterBody = host

func physics_process(host, delta):
	
	if !characterBody.is_on_floor():
		
		process_input()
		process_movement(delta)
		
		return str(name)
	
	if (characterBody.is_on_floor()):
		return str("On_Ground")

func process_input():
	
	direction = Vector3()
	
	if Input.is_action_pressed("Foward"):
		direction -= characterBody.transform.basis.z
	if Input.is_action_pressed("Backward"):
		direction += characterBody.transform.basis.z
	if Input.is_action_pressed("Left"):
		direction -= characterBody.transform.basis.x
	if Input.is_action_pressed("Right"):
		direction += characterBody.transform.basis.x
	

func process_movement(delta):
	# Get the normalized input direction so that we don't move faster on diagonals
	var wish_dir = direction.normalized()
	
	
	# Only apply gravity while in the air
	characterBody.velocity.y -= GRAVITY * delta
	characterBody.velocity = update_velocity_air(wish_dir, delta)
	
	# Move the player once velocity has been calculated
	characterBody.move_and_slide()

func accelerate(wish_dir: Vector3, max_velocity: float, delta):
	# Get our current speed as a projection of velocity onto the wish_dir
	var current_speed = characterBody.velocity.dot(wish_dir)
	# How much we accelerate is the difference between the max speed and the current speed
	# clamped to be between 0 and MAX_ACCELERATION which is intended to stop you from going too fast
	var add_speed = clamp(max_velocity - current_speed, 0, MAX_ACCELERATION * delta)
	
	return characterBody.velocity + add_speed * wish_dir

func update_velocity_air(wish_dir : Vector3, delta):
	# Do not apply any friction
	return accelerate(wish_dir, MAX_VELOCITY_AIR, delta)
