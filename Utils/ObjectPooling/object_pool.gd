class_name ObjectPool
extends Node


@export var object_scene: PackedScene

@export_category("Limits")
@export var maximum_objects: int = 0

var objects_pooled: Array[Node] = []
var all_objects: Array[Node] = []


func _init(scene: PackedScene, max_objects: int = 0) -> void:
	self.maximum_objects = max_objects
	self.object_scene = scene


func get_object() -> Node:
	
	var object_found: Node = null
	
	if maximum_objects == 0 or all_objects.size() <= maximum_objects:
		if objects_pooled.size() == 0: create_new_object()
		
		object_found = objects_pooled[0]
		objects_pooled.remove_at(0)
	
	return object_found


func create_new_object() -> void:
	var new_object: Node = object_scene.instantiate()
	objects_pooled.append(new_object)
	all_objects.append(new_object)
	print("Created object")
	new_object.tree_exiting.connect(_on_removed_from_parent.bind(new_object))


func _on_removed_from_parent(node: Node) -> void:
	objects_pooled.append(node)
