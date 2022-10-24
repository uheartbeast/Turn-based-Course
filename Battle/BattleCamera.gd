extends Camera2D
class_name BattleCamera

func focus_target(target : BattleUnit, duration : float = 0.4) -> void:
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	var target_position := Vector2(target.global_position.x, global_position.y)
	tween.tween_property(self, "global_position", target_position, duration)
	tween.parallel().tween_property(self, "zoom", Vector2(0.75, 0.75), duration).from_current()
	yield(tween, "finished")
