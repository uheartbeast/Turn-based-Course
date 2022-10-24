extends HBoxContainer
class_name BattleMenu

enum {
	ACTION,
	ITEM,
	RUN
}

onready var action_button = $"%ActionButton"
onready var item_button = $"%ItemButton"
onready var run_button = $"%RunButton"

signal menu_option_selected(option)

func grab_action_focus() -> void:
	action_button.grab_focus()

func _on_ActionButton_button_down():
	emit_signal("menu_option_selected", ACTION)

func _on_ItemButton_button_down():
	emit_signal("menu_option_selected", ITEM)

func _on_RunButton_button_down():
	emit_signal("menu_option_selected", RUN)
