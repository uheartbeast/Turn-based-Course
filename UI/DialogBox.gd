extends TextureRect

var typer : SceneTreeTween
var is_typing : bool = false

onready var textbox := $"%Textbox"
onready var portrait := $"%Portrait"

signal dialog_finished

func set_visible_characters(index : int) -> void:
#	var is_new_character : bool = index > textbox.visible_characters
	textbox.visible_characters = index
	
