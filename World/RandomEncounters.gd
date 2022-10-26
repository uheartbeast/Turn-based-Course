extends Sprite

export(Array, Resource) var encounters := []

func _ready() -> void:
	randomize()
	ReferenceStash.random_encounters = encounters
	hide()

func _exit_tree() -> void:
	ReferenceStash.random_encounters = []
