extends Camera3D

@export var characterBody : CharacterBody3D

@export var mouse_sens : float = 0.05

@onready var camera : Camera3D = self
@onready var subviewport_camera : Camera3D = $"../PlayerInterface/SubViewportContainer/SubViewport/SubViewPort_Camera"

func _ready() -> void:
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(_delta: float) -> void:
	subviewport_camera.set_global_transform(camera.get_global_transform())
	if Input.is_action_just_pressed("Escape"):
			get_tree().quit()

func _input(event: InputEvent):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		characterBody.rotate_y(deg_to_rad(-event.relative.x * mouse_sens))
		camera.rotate_x(deg_to_rad(-event.relative.y * mouse_sens))
		camera.rotation.x = clampf(camera.rotation.x, -deg_to_rad(60), deg_to_rad(90))
