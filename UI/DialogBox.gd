extends TextureRect

const CHARACTER_DISPLAY_DURATION = 0.08

var typer : SceneTreeTween
var is_typing : bool = false

onready var textbox := $"%Textbox"
onready var portrait := $"%Portrait"

func _ready() -> void:
	Events.connect("request_show_dialog", self, "type_dialog")

func _unhandled_input(event : InputEvent) -> void:
	if not visible: return
	if not event.is_action_pressed("ui_accept"): return
	
	if is_typing:
		is_typing = false
		if typer is SceneTreeTween: typer.kill()
		textbox.percent_visible = 1.0
	else:
		hide()
		get_tree().set_input_as_handled()
		get_tree().paused = false
		Events.emit_signal("dialog_finished")

func type_dialog(bbcode : String, character : Character) -> void:
	is_typing = true
	portrait.texture = character.portrait
	get_tree().paused = true
	show()
	textbox.bbcode_text = bbcode
	yield(get_tree(), "idle_frame") # Must wait for get_total_character_count to be accurate
	var total_characters : int = textbox.get_total_character_count()
	var duration : float = total_characters * CHARACTER_DISPLAY_DURATION
	typer = create_tween()
	typer.tween_method(self, "set_visible_characters", 0, total_characters, duration)
	yield(typer, "finished")
	is_typing = false

func set_visible_characters(index : int) -> void:
#	var is_new_character : bool = index > textbox.visible_characters
	textbox.visible_characters = index
	
