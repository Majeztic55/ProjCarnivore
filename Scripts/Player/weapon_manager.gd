class_name WeaponManager
extends Node

@export var animationTreeArms: AnimationTree
@export var animationPlayerArms: AnimationPlayer

@export var WeaponObjects : Array[Node3D]

var statemachine

enum weapons {Hands, Blades, Shotgun}

var currentWeapon

func _ready() -> void:
	statemachine = animationTreeArms.get("parameters/playback")
	swap_weapons(0)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("1"):
		swap_weapons(0)
	
	if Input.is_action_just_pressed("2"):
		swap_weapons(1)
	
	if Input.is_action_just_pressed("3"):
		swap_weapons(2)
	
	if Input.is_action_just_pressed("Left_Click"):
		weapon_attack(currentWeapon)

func swap_weapons(weapon: int):
	match weapon:
		0:
			currentWeapon = weapons.Hands
			animationTreeArms["parameters/conditions/hands_equipped"] = true
			animationTreeArms["parameters/conditions/blades_equipped"] = false
			animationTreeArms["parameters/conditions/shotgun_equipped"] = false
		1:
			currentWeapon = weapons.Blades
			animationTreeArms["parameters/conditions/hands_equipped"] = false
			animationTreeArms["parameters/conditions/blades_equipped"] = true
			animationTreeArms["parameters/conditions/shotgun_equipped"] = false
		2:
			currentWeapon = weapons.Shotgun
			animationTreeArms["parameters/conditions/hands_equipped"] = false
			animationTreeArms["parameters/conditions/blades_equipped"] = false
			animationTreeArms["parameters/conditions/shotgun_equipped"] = true

	print(currentWeapon)

func weapon_attack(weapon: int):
	match weapon:
		0:
			print("no attack for hands")
		1:
			var rand_animation = randi_range(0, 1)
			statemachine.travel("BladesAttack")
			animationTreeArms["parameters/BladesAttack/bladesAttackBlend/blend_amount"] = rand_animation
		2:
			statemachine.travel("PlayerShotgunShoot")

func hide_all_weapons():
	for i in WeaponObjects.size():
		WeaponObjects[i].hide()

func hide_all_weapons_but_one(weapon_index : int):
	for i in WeaponObjects.size():
		WeaponObjects[i].hide()
	WeaponObjects[weapon_index].show()
