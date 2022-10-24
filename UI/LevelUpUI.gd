extends TextureRect

onready var experience_bar := $"%ExperienceBar"

func level_up() -> void:
	show()
	experience_bar.set_bar(50, 100)
	yield(experience_bar.animate_bar(100.0, 100.0), "completed")
