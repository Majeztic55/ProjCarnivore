class_name StateMachine
extends Node

@export var current_state : State

func _ready() -> void:
	current_state.enter(self)
	print(str("current state name: " + current_state.name))

func _process(delta: float) -> void:
	var next_state_name = current_state.process(self, delta)
	if str(next_state_name) != str(current_state.name) and str(next_state_name) != "":
		change_states(next_state_name)

func _physics_process(delta) -> void:
	var next_state_name = current_state.physics_process(self, delta)
	
	if str(next_state_name) != str(current_state.name) and str(next_state_name) != "":
		change_states(next_state_name)

func change_states(next_state_name):
	print(str("next state name: " + str(next_state_name)))
	if not has_node("States/" + next_state_name):
		push_error("Node does not exist for the given state: " + str(next_state_name))
		return
	current_state.exit(self)
	current_state = get_node("States/" + next_state_name)
	current_state.enter(self)
	print(str("current state name: " + current_state.name))
