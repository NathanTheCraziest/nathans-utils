class_name RebindButton
extends Button

@export var action_name: StringName
@export var rebind_screen: Control


func _init() -> void:
	toggle_mode = true
	focus_mode = Control.FOCUS_NONE


func _ready() -> void:
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
	if event.is_pressed():
		CustomInputManager.remap_action(action_name, event)
		button_pressed = false
