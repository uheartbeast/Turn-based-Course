extends MarginContainer
class_name OverworldMenuManager

var stats : PlayerClassStats = ReferenceStash.elizabethStats
var inventory : Inventory = ReferenceStash.inventory

var uiStack := UIStack.new()

onready var overworld_menu := $"%OverworldMenu"
onready var elizabeth_stats := $"%ElizabethStats"
onready var item_list := $"%ItemList"
onready var context_menu := $"%ContextMenu"
onready var info_menu := $"%InfoMenu"
onready var timer := $Timer

var item_resource : Item

func _unhandled_input(event : InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if not uiStack.empty():
			uiStack.pop()

func _on_OverworldMenu_option_selected(option : int) -> void:
	match option:
		OverworldMenu.STATS:
			uiStack.push(elizabeth_stats)
		OverworldMenu.ITEMS:
			uiStack.push(item_list)
		OverworldMenu.EXIT:
			uiStack.pop()

func _on_ItemList_resource_selected(resource : Item) -> void:
	item_resource = resource
	uiStack.push(context_menu)

func _on_ContextMenu_option_selected(option : int):
	match option:
		ContextMenu.USE:
			print(item_resource.name)
		ContextMenu.INFO:
			info_menu.text = item_resource.description
			uiStack.push(info_menu)
