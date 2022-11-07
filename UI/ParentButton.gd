extends Button
class_name ParentButton

onready var focus_sound = $FocusSound
onready var select_sound = $SelectSound

func _on_ParentButton_focus_entered():
	focus_sound.play()

func _on_ParentButton_button_down():
	select_sound.play()
