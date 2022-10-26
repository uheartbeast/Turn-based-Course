extends PanelContainer

onready var resource_button = $MarginContainer/ScrollContainer/MarginContainer/ButtonContainer/ResourceButton

func _ready() -> void:
	resource_button.grab_focus()
