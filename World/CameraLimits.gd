extends ColorRect

func _ready() -> void:
	var camera_limits := Rect2(rect_global_position, rect_size)
	Events.emit_signal("request_update_camera_limits", camera_limits)
	hide()
