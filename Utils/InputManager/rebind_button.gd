@tool
class_name RebindButton
extends Button

@export var action_name: StringName:
	set(value):
		action_name = value
		if Engine.is_editor_hint(): update_configuration_warnings()

@export var rebind_screen: Control

var is_valid_action: bool = false


func _init() -> void:
	toggle_mode = true
	focus_mode = Control.FOCUS_NONE


func _ready() -> void:
	if not Engine.is_editor_hint():
		self.toggled.connect(_toggled)
		set_process_unhandled_input(false)
		update_text()


func update_text() -> void:
	text = InputMap.action_get_events(action_name).front().as_text()


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
