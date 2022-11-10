extends FocusMenu
class_name OverworldMenu

enum {STATS, ITEMS, SAVE, LOAD, EXIT}

signal option_selected(option)

func _on_StatsButton_button_down():
	emit_signal("option_selected", STATS)

func _on_ItemsButton_button_down():
	emit_signal("option_selected", ITEMS)

func _on_SaveButton_button_down():
	emit_signal("option_selected", SAVE)

func _on_LoadButton_button_down():
	emit_signal("option_selected", LOAD)

func _on_ExitButton_button_down():
	emit_signal("option_selected", EXIT)


