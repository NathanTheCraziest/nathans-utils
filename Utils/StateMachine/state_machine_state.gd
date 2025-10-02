class_name StateMachineState
extends Node


func _ready() -> void:
	if not get_state_machine().initial_state == self:
		process_mode = Node.PROCESS_MODE_DISABLED
	else:
		process_mode = Node.PROCESS_MODE_INHERIT


func get_state_machine() -> StateMachine:
	if get_parent() is StateMachine:
		return get_parent() as StateMachine
	else:
		return null


func enter_state() -> void:
	process_mode = Node.PROCESS_MODE_INHERIT
	_on_entered_state()


func exit_state() -> void:
	_on_extied_state()
	process_mode = Node.PROCESS_MODE_DISABLED


func _on_entered_state() -> void:
	pass


func _on_extied_state() -> void:
	pass
