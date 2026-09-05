class_name StateMachine
extends Node

@export var initial_state: State

var current_state: State
var states: Dictionary = {}

func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.transitioned.connect(_on_child_transitioned)

	if initial_state:
		current_state = initial_state
		current_state.enter()

func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)

func _unhandled_input(event: InputEvent) -> void:
	if current_state:
		current_state.handle_input(event)

func _on_child_transitioned(state_name: String) -> void:
	transition_to(state_name)

func transition_to(state_name: String) -> void:
	var new_state: State = states.get(state_name.to_lower())
	if not new_state or new_state == current_state:
		return
	if not new_state.can_enter():
		return
	if current_state:
		current_state.exit()
	new_state.enter()
	current_state = new_state
