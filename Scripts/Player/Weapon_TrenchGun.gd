class_name TrenchGun
extends Node3D

@onready var player_camera = $"../../../../.."

var raycast_test_sphere = preload("res://Scenes/Utility/raycast_test_sphere.tscn")

var range = 1000

func Shoot():
	
	var space_state = player_camera.get_world_3d().direct_space_state
	var screen_centre = player_camera.get_viewport().size / 2
	var origin = player_camera.project_ray_origin(screen_centre)
	
	var end = origin + player_camera.project_ray_normal(screen_centre) * range
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_bodies = true
	var result = space_state.intersect_ray(query)
	if result:
		test_raycast(result.position)

func test_raycast(position : Vector3) -> void:
	var instance = raycast_test_sphere.instantiate()
	get_tree().root.add_child(instance)
	instance.global_position = position
	await get_tree().create_timer(3).timeout
	instance.queue_free()
