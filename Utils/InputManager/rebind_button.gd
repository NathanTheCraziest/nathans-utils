@tool
class_name RebindButton
extends Button

@export var action_name: StringName:
	set(value):
		action_name = value
		if Engine.is_editor_hint(): update_configuration_warnings()

@export var rebind_screen: Control


func _init() -> void:
	toggle_mode = true
	focus_mode = Control.FOCUS_NONE


func _ready() -> void:
	if not Engine.is_editor_hint():
		self.toggled.connect(_toggled)
		set_process_unhandled_input(false)
		
		CustomInputManager.on_action_input_changed.connect(_on_action_input_changed)
		
		await get_tree().process_frame
		
		update_text()


func _on_action_input_changed(_action_name: StringName) -> void:
	if action_name == _action_name:
		update_text()


func _toggled(_pressed):
	set_process_unhandled_input(_pressed)
	if _pressed:
		text = "..."
		if rebind_screen: rebind_screen.show()
	else:
		update_text()
		if rebind_screen: rebind_screen.hide()


func _unhandled_input(event):
	if event.is_pressed() and not Engine.is_editor_hint():
		CustomInputManager.remap_action(action_name, event)
		button_pressed = false


func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	if not ProjectSettings.has_setting("input/" + action_name):
		warnings.append("Action '%s' does not exist in Input Map." % action_name)
	return warnings


func update_text() -> void:
	print(InputMap.action_get_events(action_name).front().physical_keycode)
	text = OS.get_keycode_string(InputMap.action_get_events(action_name).front().physical_keycode)


func reset_action() -> void:
	CustomInputManager.reset_action(action_name)
