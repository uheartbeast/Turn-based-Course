extends FocusMenu
class_name OverworldMenu

enum {STATS, ITEMS, EXIT}

signal option_selected(option)

func _on_StatsButton_button_down():
	emit_signal("option_selected", STATS)

func _on_ItemsButton_button_down():
	emit_signal("option_selected", ITEMS)

func _on_ExitButton_button_down():
	emit_signal("option_selected", EXIT)
