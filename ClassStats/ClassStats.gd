extends Resource
class_name ClassStats

export(String) var name
export(int) var max_health setget set_max_health
export(int) var attack
export(int) var defense

export(PackedScene) var battle_animations

var level := 1
var health := 1 setget set_health

signal health_changed
signal no_health
signal max_health_changed
signal level_changed

func set_health(value : int) -> void:
	health = clamp(value, 0, max_health)
	emit_signal("health_changed")
	if health == 0: emit_signal("no_health")

func set_max_health(value : int) -> void:
	max_health = value
	health = max_health
	emit_signal("max_health_changed")
