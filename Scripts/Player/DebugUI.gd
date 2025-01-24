extends PanelContainer

@export var characterBody : CharacterBody3D

@export var debug_label : Label

func _process(delta: float) -> void:
	
	debug_speed()
	

func debug_speed():
	debug_label.text = "Speed: %.2f" % characterBody.velocity.length()
	debug_label.text += "\n Direction: x %.2f, y %.2f z %.2f" % [characterBody.velocity.x, characterBody.velocity.y, characterBody.velocity.z]
