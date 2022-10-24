extends Control

var stats : ClassStats setget set_stats

onready var health_bar := $HealthBar
onready var level_label := $LevelLabel

func set_stats(value : ClassStats) -> void:
	stats = value
	connect_stats()

func update_level() -> void:
	level_label.text = "Level : " + str(stats.level)

func connect_stats() -> void:
	if not stats is ClassStats: return
	stats.connect("health_changed", self, "_on_stats_health_changed")
	stats.connect("level_changed", self, "_on_stats_level_changed")
	health_bar.set_bar(stats.health, stats.max_health)
	update_level()

func _on_stats_health_changed() -> void:
	health_bar.animate_bar(stats.health, stats.max_health)

func _on_stats_level_changed() -> void:
	update_level()
