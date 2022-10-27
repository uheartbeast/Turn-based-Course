extends PanelContainer

onready var rich_text_label = $"%RichTextLabel"

var text := "" setget set_text

func set_text(value : String) -> void:
	text = value
	rich_text_label.text = text
