extends PanelContainer
class_name ScrollList

onready var resource_button := $MarginContainer/ScrollContainer/MarginContainer/ButtonContainer/ResourceButton
onready var scroll_container := $"%ScrollContainer"
onready var button_container := $"%ButtonContainer"

func _ready() -> void:
	resource_button.grab_focus()
	connect_scroll_children()

func connect_scroll_children() -> void:
	for button in button_container.get_children():
		if button.is_connected("focus_entered", self, "_on_button_focused"): continue
		button.connect("focus_entered", self, "_on_button_focused")

func _on_button_focused() -> void:
	var focused_button := get_focus_owner()
	if not focused_button in button_container.get_children(): return # Exit if the focus is not a child button
	var focused_scroll_amount := get_focused_scroll_amount()
	var tween := create_tween()
	tween.tween_property(scroll_container, "scroll_vertical", focused_scroll_amount, 0.1).from_current()

func get_focused_scroll_amount() -> int:
	var focused_button := get_focus_owner()
	var previous_scroll : int = scroll_container.scroll_vertical
	scroll_container.ensure_control_visible(focused_button)
	var focused_scroll_amount : int = scroll_container.scroll_vertical
	scroll_container.scroll_vertical = previous_scroll
	return focused_scroll_amount
