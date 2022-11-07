extends PanelContainer

var stats : PlayerClassStats = ReferenceStash.elizabethStats

onready var level := $"%Level"
onready var health_bar := $"%HealthBar"
onready var experience_bar := $"%ExperienceBar"

signal animation_finished

func _ready() -> void:
	if not stats.is_connected("health_changed", self, "_on_health_changed"):
		stats.connect("health_changed", self, "_on_health_changed")
	update_stats()

func update_stats() -> void:
	level.text = "Level : " + str(stats.level)
	health_bar.set_bar(stats.health, stats.max_health)
	experience_bar.set_bar(stats.experience, stats.MAX_EXPERIENCE)

func _on_health_changed() -> void:
	health_bar.animate_bar(stats.health, stats.max_health)
	yield(health_bar, "animation_finished")
	emit_signal("animation_finished")

func _enter_tree() -> void:
	request_ready()
