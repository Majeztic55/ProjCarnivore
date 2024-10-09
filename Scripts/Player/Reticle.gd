extends CenterContainer

@export var RETICULE_LINES : Array[Line2D]
@export var PLAYER_CONTROLLER : CharacterBody3D
@export var RETICULE_SPEED : float = 0.25
@export var RETICULE_DISTANCE : float = 2.0

@export var DOT_RADIUS : float = 1.0
@export var DOT_COLOUR : Color = Color.WHITE

func _ready() -> void:
	queue_redraw()

func _process(_delta: float) -> void:
	adjust_reticule_lines()

func _draw() -> void:
	draw_circle(Vector2(0,0), DOT_RADIUS, DOT_COLOUR)

func adjust_reticule_lines():
	var velocity = PLAYER_CONTROLLER.get_real_velocity()
	var origin = Vector3.ZERO
	var pos = Vector2.ZERO
	var speed = origin.distance_to(velocity)
	
	#right reticule 
	RETICULE_LINES[0].position = lerp(RETICULE_LINES[0].position, pos + Vector2(speed * RETICULE_DISTANCE, 0), RETICULE_SPEED)
	#bottom reticule 
	RETICULE_LINES[1].position = lerp(RETICULE_LINES[1].position, pos + Vector2(0, speed * RETICULE_DISTANCE), RETICULE_SPEED)
	#left reticule 
	RETICULE_LINES[2].position = lerp(RETICULE_LINES[2].position, pos + Vector2(-speed * RETICULE_DISTANCE, 0), RETICULE_SPEED)
