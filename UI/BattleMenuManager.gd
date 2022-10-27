extends Control

var elizabethStats : PlayerClassStats = ReferenceStash.elizabethStats

var uiStack := UIStack.new()

onready var battle_menu := $"%BattleMenu"
onready var action_list := $"%ActionList"
onready var item_list := $"%ItemList"
onready var context_menu = $"%ContextMenu"

func _ready() -> void:
	action_list.fill(elizabethStats.battle_actions)
	item_list.fill(elizabethStats.inventory.items)
	yield(battle_menu.show_menu(), "completed")
	uiStack.push(battle_menu)

func _unhandled_input(event : InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		uiStack.pop()

func _on_BattleMenu_menu_option_selected(option : int) -> void:
	match option:
		BattleMenu.ACTION:
			uiStack.push(action_list)
		
		BattleMenu.ITEM:
			uiStack.push(item_list)

func _on_ActionList_resource_selected(resource : BattleAction) -> void:
	uiStack.push(context_menu)
	print(resource.name)

func _on_ItemList_resource_selected(resource : Item) -> void:
	uiStack.push(context_menu)
	print(resource.name)

func _on_ContextMenu_option_selected(option : int) -> void:
	match option:
		ContextMenu.USE: print("use")
		ContextMenu.INFO: print("info")
