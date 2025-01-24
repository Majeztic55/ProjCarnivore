extends State

class_name Wall_Running_State

var characterBody : CharacterBody3D

const MAX_VELOCITY_GROUND = 12.0
const MAX_ACCELERATION = 10 * MAX_VELOCITY_GROUND
const GRAVITY = 1
const STOP_SPEED = 1.5

var friction = 4

var direction = Vector3()

var wall_normal

@export var animationTreeArms : AnimationTree
@export var animationTreeLegs : AnimationTree
@export var weapon_manager : WeaponManager

func enter(host):
	characterBody = host
	wall_normal = characterBody.get_slide_collision(0)

func exit(host):
	wall_normal = null

func physics_process(host, delta):
	if characterBody.is_on_wall() && !characterBody.is_on_floor() && Input.is_action_pressed("Jump") && Input.is_action_pressed("Foward"):
			
			process_input()
			process_movement(delta)
			manage_animationTreeLegs()
			manage_animationTreeArms()
			return str(name)
	elif characterBody.is_on_floor():
		return str("On_Ground")
	else:
		return str("In_Air")
	
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
	
	direction += -wall_normal.get_normal() * (MAX_VELOCITY_GROUND / 10)
	

func process_movement(delta):
	# Get the normalized input direction so that we don't move faster on diagonals
	var wish_dir = direction.normalized()
	
	characterBody.velocity.y -= GRAVITY * delta
	
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

func manage_animationTreeLegs():
	var blendAmount : float
	blendAmount = characterBody.velocity.length() / MAX_VELOCITY_GROUND
	
	animationTreeLegs["parameters/IdleToWalking/IdleToWalkingBlend/blend_amount"] = blendAmount
	

func manage_animationTreeArms():
	var blendAmount : float
	blendAmount = characterBody.velocity.length() / MAX_VELOCITY_GROUND
	
	match weapon_manager.currentWeapon:
		0:
			animationTreeArms["parameters/Hands/HandsIdleToWalking/blend_amount"] = blendAmount
		1:
			animationTreeArms["parameters/Blades/BladesIdleToWalk/blend_amount"] = blendAmount
		2:
			animationTreeArms["parameters/Shotgun/ShotgunIdleToWalk/blend_amount"] = blendAmount
	
