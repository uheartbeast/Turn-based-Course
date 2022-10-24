extends Control

var stats : ClassStats setget set_stats

onready var health_bar := $HealthBar
onready var level_label := $LevelLabel

func set_stats(value : ClassStats) -> void:
	stats = value
	connect_stats()

func connect_stats() -> void:
	if not stats is ClassStats: return
	stats.connect("health_changed", self, "_on_stats_health_changed")
	health_bar.set_bar(stats.health, stats.max_health)
	level_label.text = "Level : " + str(stats.level)

func _on_stats_health_changed() -> void:
	health_bar.animate_bar(stats.health, stats.max_health)
