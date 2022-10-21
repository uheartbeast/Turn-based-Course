extends Resource
class_name AsyncTurnPool

var active_nodes := []

signal turn_over

func add(node : Node) -> void:
	active_nodes.append(node)

func remove(node : Node) -> void:
	if active_nodes.empty(): return
	active_nodes.erase(node)
	if active_nodes.empty(): emit_signal("turn_over")
