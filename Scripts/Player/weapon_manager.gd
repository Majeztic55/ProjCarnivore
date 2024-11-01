extends Node

@export var animationTreeArms: AnimationTree

enum weapons {Hands, Blades}

var currentWeapon

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("1"):
		swap_weapons(0)
		
	if Input.is_action_just_pressed("2"):
		swap_weapons(1)
		
	

func swap_weapons(weapon: int):
	match weapon:
		0:
			currentWeapon = weapons.Hands
		1:
			currentWeapon = weapons.Blades
	print(currentWeapon)
