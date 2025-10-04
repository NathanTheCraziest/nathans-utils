extends Node

var default_action_events: Dictionary[StringName, InputEvent]
var custom_action_events: Dictionary[StringName, InputEvent]

var input_configs: ConfigFile
const input_save_path: String = "user://inputs.cfg"
var save_section: String = "player_inputs_0"


func _ready() -> void:
	
	load_custom_inputs()
	
	for action: StringName in InputMap.get_actions():
		
		if not action.begins_with("ui_"):
			var event: InputEvent = InputMap.action_get_events(action).front()
			
			default_action_events.get_or_add(action, event)
	
	for custom_actions: StringName in custom_action_events.keys():
		remap_action(custom_actions, custom_action_events.get(custom_actions))


func remap_action(action_name: StringName, input_event: InputEvent) -> void:
	if default_action_events.has(action_name):
		custom_action_events.set(action_name, input_event)
		save_custom_input()
		InputMap.action_erase_events(action_name)
		InputMap.action_add_event(action_name, input_event)
	else:
		printerr("No input actions by the name \"%s\" was found.")


func reset_action(action_name: StringName) -> void:
	if default_action_events.has(action_name):
		custom_action_events.set(action_name, default_action_events.get(action_name))
		save_custom_input()
		InputMap.action_erase_events(action_name)
		InputMap.action_add_event(action_name, default_action_events.get(action_name))
	else:
		printerr("No input actions by the name \"%s\" was found.")


func load_custom_inputs() -> void:
	
	input_configs = ConfigFile.new()
	input_configs.load(input_save_path)
	
	var custom_inputs: Dictionary = input_configs.get_value(save_section, "custom_action_events", {})
	if custom_inputs is Dictionary[StringName, InputEvent]:
		custom_action_events = custom_inputs


func save_custom_input() -> void:
	input_configs.set_value(save_section, "custom_action_events", custom_action_events)
	input_configs.save(input_save_path)
