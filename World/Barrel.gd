extends Interactable

func _run_interaction() -> void:
	Events.emit_signal("request_show_message", "It's just a barrel...")
