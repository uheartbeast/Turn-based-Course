extends CanvasLayer

onready var color_rect := $ColorRect

func fade_to_color(color : Color, duration : float = 0.5) -> void:
	var tween := create_tween()
	tween.tween_property(color_rect, "color", color, duration).from_current()

func fade_from_color(color : Color, duration : float = 0.5) -> void:
	var tween := create_tween()
	color.a = 0.0
	tween.tween_property(color_rect, "color", color, duration).from_current()
