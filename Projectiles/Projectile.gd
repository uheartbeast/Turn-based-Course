extends Node2D
class_name Projectile

var asyncTurnPool : AsyncTurnPool = ReferenceStash.asyncTurnPool

func move_to(target: BattleUnit) -> void:
	asyncTurnPool.add(self)
	var tween := create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "global_position", target.global_position, 0.2).from_current()
	yield(tween, "finished")
	asyncTurnPool.remove(self)
	queue_free()
