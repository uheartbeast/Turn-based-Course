extends ClassStats
class_name PlayerClassStats

const MAX_EXPERIENCE := 100

export(Resource) var inventory : Resource

var experience := 0 setget set_experience

func set_experience(value : int) -> void:
	experience = value
	while experience >= MAX_EXPERIENCE:
		experience = experience - MAX_EXPERIENCE
		level += 1
		emit_signal("level_changed")
