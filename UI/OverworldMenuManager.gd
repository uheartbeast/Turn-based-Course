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
onready var heal_sound := $HealSound

var item_resource : Item

func _ready() -> void:
	Events.connect("request_show_overworld_menu", self, "_on_request_show_overworld_menu")

func use_healing_item(item: HealingItem) -> void:
	set_process_unhandled_input(false)
	uiStack.pop()
	uiStack.pop()
	uiStack.push(elizabeth_stats)
	inventory.remove_item(item)
	heal_sound.play()
	stats.health += item.heal_amount
	yield(elizabeth_stats, "animation_finished")
	timer.start(0.25)
	yield(timer, "timeout")
	uiStack.pop()
	uiStack.push(item_list)
	set_process_unhandled_input(true)

func _unhandled_input(event : InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if not uiStack.empty():
			uiStack.pop()
			if uiStack.empty():
				get_tree().set_input_as_handled()
				get_tree().paused = false

func _on_request_show_overworld_menu() -> void:
	uiStack.push(overworld_menu)
	get_tree().paused = true

func _on_OverworldMenu_option_selected(option : int) -> void:
	match option:
		OverworldMenu.STATS:
			uiStack.push(elizabeth_stats)
		OverworldMenu.ITEMS:
			uiStack.push(item_list)
		OverworldMenu.SAVE:
			get_tree().set_input_as_handled()
			SaveManager.save_game()
			uiStack.pop()
			Events.emit_signal("request_show_message", "Game save!")
		OverworldMenu.LOAD:
			get_tree().set_input_as_handled()
			get_tree().paused = false
			SaveManager.load_game()
		OverworldMenu.EXIT:
			uiStack.pop()
			get_tree().paused = false

func _on_ItemList_resource_selected(resource : Item) -> void:
	item_resource = resource
	uiStack.push(context_menu)

func _on_ContextMenu_option_selected(option : int):
	match option:
		ContextMenu.USE:
			if item_resource is HealingItem:
				if stats.health < stats.max_health:
					use_healing_item(item_resource)
				else:
					info_menu.text = "Your health is already full."
					uiStack.push(info_menu)
		ContextMenu.INFO:
			info_menu.text = item_resource.description
			uiStack.push(info_menu)
