extends Node

onready var current_scene := get_tree().current_scene

func _ready() -> void:
	get_parent().connect("tree_exiting", self, "reparent")

func reparent() -> void:
	if not is_instance_valid(current_scene): return
	var parent := get_parent()
	parent.remove_child(self)
	current_scene.call_deferred("add_child", self)
