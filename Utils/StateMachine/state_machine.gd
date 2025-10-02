class_name StateMachine
extends Node

var states_dict: Dictionary[String, StateMachineState]
var states_list: Array[StateMachineState]


var current_state: StateMachineState

@export var initial_state: StateMachineState


func _ready() -> void:
	for child: Node in get_children():
		if child is StateMachineState:
			states_dict.get_or_add(child.name, child)
			states_list.append(child)
			
			if initial_state == null:
				initial_state = child
	
	current_state = initial_state
	current_state.enter_state()


func change_state(state: StateMachineState) -> void:
	current_state.exit_state()
	current_state = state
	current_state.enter_state()


func change_state_by_index(index: int) -> void:
	if index + 1 <= states_list.size():
		current_state.exit_state()
		current_state = states_list[index]
		current_state.enter_state()
	else: printerr("Attempted to enter state by index \'%s\'. No state was found." % index)


func change_state_by_name(_name: String) -> void:
	if states_dict.has(_name):
		current_state.exit_state()
		current_state = states_dict[_name]
		current_state.enter_state()
	else: printerr("Attempted to enter state by key \'%s\'. No state was found." % _name)
