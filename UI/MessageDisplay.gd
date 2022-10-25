extends CenterContainer

onready var label = $"%Label"

func _ready() -> void:
	show_message("Hi, this is a new message")

func _input(event : InputEvent) -> void:
	if not visible: return
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("ui_cancel"):
		get_tree().paused = false
		get_tree().set_input_as_handled()
		hide()

func show_message(message : String) -> void:
	show()
	get_tree().paused = true
	label.text = message
