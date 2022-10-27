extends Control

var elizabethStats : PlayerClassStats = ReferenceStash.elizabethStats

onready var battle_menu := $"%BattleMenu"
onready var action_list := $"%ActionList"
onready var item_list := $"%ItemList"

func _ready() -> void:
	action_list.fill(elizabethStats.battle_actions)
	item_list.fill(elizabethStats.inventory.items)
	yield(battle_menu.show_menu(), "completed")
	battle_menu.grab_focus()

func _unhandled_input(event : InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		action_list.release_focus()
		item_list.release_focus()
		action_list.hide()
		item_list.hide()
		battle_menu.grab_focus()

func _on_BattleMenu_menu_option_selected(option : int) -> void:
	match option:
		BattleMenu.ACTION:
			battle_menu.release_focus()
			action_list.show()
			action_list.grab_focus()
		
		BattleMenu.ITEM:
			battle_menu.release_focus()
			item_list.show()
			item_list.grab_focus()

func _on_ActionList_resource_selected(resource : BattleAction):
	print(resource.name)

func _on_ItemList_resource_selected(resource : Item):
	print(resource.name)
