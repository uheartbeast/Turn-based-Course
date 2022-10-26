extends NPC

func _run_interaction() -> void:
	Events.emit_signal("request_show_dialog", "Aaaaaah! I have a head ache.", character)
	yield(Events, "dialog_finished")
	Events.emit_signal("request_show_dialog", "Can you find a potion?", character)
	yield(Events, "dialog_finished")
	Events.emit_signal("request_show_dialog", "I'll look around for you.", load("res://Characters/ElizabethCharacter.tres"))
	yield(Events, "dialog_finished")
