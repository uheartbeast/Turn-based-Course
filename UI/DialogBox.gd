extends TextureRect

const CHARACTER_DISPLAY_DURATION = 0.08

var typer : SceneTreeTween
var is_typing : bool = false

onready var textbox := $"%Textbox"
onready var portrait := $"%Portrait"

signal dialog_finished

func _ready() -> void:
	type_dialog("Hi, here is some test dialog.", load("res://Characters/ElizabethCharacter.tres"))

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
	emit_signal("dialog_finished")

func set_visible_characters(index : int) -> void:
#	var is_new_character : bool = index > textbox.visible_characters
	textbox.visible_characters = index
	
