extends Node2D
class_name Projectile

var asyncTurnPool : AsyncTurnPool = ReferenceStash.asyncTurnPool

func move_to(target: BattleUnit) -> void:
	asyncTurnPool.add(self)
	var tween := create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_IN)
	var target_position := Vector2(target.global_position.x, global_position.y)
	tween.tween_property(self, "global_position", target_position, 0.4).from_current()
	yield(tween, "finished")
	asyncTurnPool.remove(self)
	queue_free()
