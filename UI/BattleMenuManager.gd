extends Control

onready var battle_menu := $"%BattleMenu"
onready var action_list := $"%ActionList"
onready var item_list := $"%ItemList"

func _ready() -> void:
	battle_menu.show_menu()
