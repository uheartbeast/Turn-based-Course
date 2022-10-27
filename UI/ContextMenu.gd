extends FocusMenu
class_name ContextMenu

enum { USE, INFO }

signal option_selected(option)

func _on_UseButton_button_down():
	emit_signal("option_selected", USE)

func _on_InfoButton_button_down():
	emit_signal("option_selected", INFO)
