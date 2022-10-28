extends Node2D
class_name Projectile

var asyncTurnPool : AsyncTurnPool = ReferenceStash.asyncTurnPool

export(float) var travel_duration := 0.5

signal contact
signal collision_animation_finished

func move_to(target: BattleUnit, trans : int = Tween.TRANS_LINEAR, easing: int = Tween.EASE_IN) -> void:
	z_index = 25
	asyncTurnPool.add(self)
	var tween := create_tween().set_trans(trans).set_ease(easing)
	var target_position := Vector2(target.global_position.x, global_position.y)
	tween.tween_property(self, "global_position", target_position, travel_duration).from_current()
	yield(tween, "finished")
	emit_signal("contact")
	_animate_collision()
	yield(self, "collision_animation_finished")
	asyncTurnPool.remove(self)
	queue_free()

func _animate_collision() -> void:
	yield(get_tree(), "idle_frame")
