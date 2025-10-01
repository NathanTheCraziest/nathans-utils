class_name ObjectPool
extends Node


@export var object_scene: PackedScene

@export_category("Limits")
@export var maximum_objects: int = 0

var objects_pooled: Array[Node] = []


func get_object() -> Node:
	
	var object_found: Node = null
	
	if objects_pooled.size() == 0: create_new_object()
	
	object_found = objects_pooled[0]
	objects_pooled.remove_at(0)
	
	return object_found


func create_new_object() -> void:
	var new_object: Node = object_scene.instantiate()
	objects_pooled.append(new_object)
	print("Created object")
	new_object.tree_exiting.connect(_on_removed_from_parent.bind(new_object))


func _on_removed_from_parent(node: Node) -> void:
	objects_pooled.append(node)
