extends Resource
class_name UIStack

var uis := []

signal ui_popped(ui)
signal ui_stack_empty()

func push(uiToPush : Control) -> void:
	if not empty(): uis.back().release_focus()
	uis.append(uiToPush)
	uiToPush.show() # Must show first or grab_focus won't work
	uiToPush.grab_focus()

func pop() -> Control:
	if empty(): return null
	var uiToPop : Control = uis.pop_back()
	uiToPop.release_focus() # Must release focus before hiding, or it won't work
	uiToPop.hide()
	if not empty():
		uis.back().show()
		uis.back().grab_focus()
	emit_signal("ui_popped", uiToPop)
	if empty():
		emit_signal("ui_stack_empty")
	return uiToPop

func hide_uis() -> void:
	for ui in uis:
		ui.hide()

func clear() -> void:
	hide_uis()
	uis.clear()

func empty() -> bool:
	return uis.empty()
