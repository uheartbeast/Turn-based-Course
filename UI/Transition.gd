extends CanvasLayer

onready var color_rect := $ColorRect

func fade_to_color(color : Color, duration : float = 0.25) -> void:
	var tween := create_tween()
	var color_no_alpha = Color(color.r, color.g, color.b, 0)
	tween.tween_property(color_rect, "color", color, duration).from(color_no_alpha)
	yield(tween, "finished")

func fade_from_color(color : Color, duration : float = 0.25) -> void:
	var tween := create_tween()
	var color_no_alpha = Color(color.r, color.g, color.b, 0)
	tween.tween_property(color_rect, "color", color_no_alpha, duration).from(color)
	yield(tween, "finished")

func set_color(color: Color) -> void:
	color_rect.color = color
