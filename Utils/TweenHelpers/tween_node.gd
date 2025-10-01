@tool
class_name TweenNode
extends Node


@export_category("Target")
@export var target_node: Node
@export var tween_property: StringName:
	set(value):
		tween_property = value
		
		if Engine.is_editor_hint():
			if value in target_node:
				
				initial_value = target_node.get(value)
				target_value = target_node.get(value)

@export_category("Values")
@export var initial_value: Variant
@export var target_value: Variant

@export_category("Transition")
@export var duration: float = 1.0
@export var easing: Tween.EaseType
@export var transition: Tween.TransitionType

@export_category("Options")
@export var set_initial_value: bool = true

var tween: Tween


func _ready() -> void:
	if Engine.is_editor_hint() and target_node == null:
		target_node = get_parent()


func play(_duration: float = 0.0, _target_val: Variant = null, _init_val: Variant = null) -> void:
	
	if target_node:
		if tween: tween.kill()
		
		if set_initial_value: target_node.set(
			tween_property, 
			initial_value if _init_val == null else _init_val
			)
		
		tween = create_tween()
		
		tween.tween_property(
			target_node,
			NodePath(tween_property),
			target_value if _target_val == null else _target_val,
			duration if _duration <= 0.0 else _duration
			).set_ease(easing).set_trans(transition)


func stop() -> void:
	if tween: tween.stop()
