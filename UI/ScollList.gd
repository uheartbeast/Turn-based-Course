extends PanelContainer
class_name ScrollList

var elizabethStats : PlayerClassStats = ReferenceStash.elizabethStats

const ResourceButtonScene := preload("res://UI/ResourceButton.tscn")

onready var scroll_container := $"%ScrollContainer"
onready var button_container := $"%ButtonContainer"

func _ready() -> void:
	fill(elizabethStats.battle_actions)
	connect_scroll_children()
	button_container.get_child(0).grab_focus()

func fill(resource_list : Array) -> void:
	for resource in resource_list:
		var resource_button : ResourceButton = add_resource_button()
		resource_button.resource = resource
		resource_button.text = resource.name

func add_resource_button() -> ResourceButton:
	var resource_button : ResourceButton = ResourceButtonScene.instance()
	button_container.add_child(resource_button)
	resource_button.connect("resource_selected", self, "_on_resource_selected")
	return resource_button

func clear() -> void:
	for button in button_container.get_children():
		button.queue_free()

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

func _on_resource_selected(resource: Resource) -> void:
	print(resource.name)
