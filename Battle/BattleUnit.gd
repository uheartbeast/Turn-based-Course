extends Node2D
class_name BattleUnit

const ATTACK_OFFSET = 48
const KNOCKBACK_AMOUNT = 24

var asyncTurnPool : AsyncTurnPool = ReferenceStash.asyncTurnPool

export(Resource) var stats setget set_stats

var battle_animations : BattleAnimations

onready var root_position := global_position

func set_stats(value : ClassStats) -> void:
	stats = value
	if not stats is ClassStats: return
	if battle_animations is BattleAnimations: battle_animations.queue_free()
	battle_animations = stats.battle_animations.instance()
	add_child(battle_animations)

func melee_attack(target : BattleUnit) -> void:
	asyncTurnPool.add(self)
	z_index = 10
	battle_animations.play("Approach")
	var target_position := target.global_position.move_toward(global_position, ATTACK_OFFSET)
	var animation_duration := battle_animations.get_current_animation_length()
	interpolate_position(global_position, target_position, animation_duration)
	yield(battle_animations, "animation_finished")
	
	deal_damage(target)
	target.take_hit(self)
	
	battle_animations.play("Melee")
	yield(battle_animations, "animation_finished")
	
	battle_animations.play("Return")
	animation_duration = battle_animations.get_current_animation_length()
	interpolate_position(global_position, root_position, animation_duration)
	yield(battle_animations, "animation_finished")
	
	battle_animations.play("Idle")
	z_index = 0
	asyncTurnPool.remove(self)

func deal_damage(target: BattleUnit) -> void:
	var damage = ((stats.level*3 + (1-target.stats.defense * 0.05)) / 2) * (stats.attack/6)
	target.stats.health -= damage

func take_hit(attacker: BattleUnit) -> void:
	asyncTurnPool.add(self)
	var knockback_position := global_position.move_toward(attacker.global_position, -KNOCKBACK_AMOUNT)
	interpolate_position(global_position, knockback_position, 0.2, Tween.TRANS_CIRC, Tween.EASE_OUT)
	
	if stats.health == 0:
		battle_animations.play("Death")
		yield(battle_animations, "animation_finished")
		asyncTurnPool.remove(self)
		queue_free()
		return
	else:
		battle_animations.play("Hit")
		yield(battle_animations, "animation_finished")
		battle_animations.play("Idle")

	yield(interpolate_position(global_position, root_position, 0.2, Tween.TRANS_CIRC), "completed")
	asyncTurnPool.remove(self)

func interpolate_position(start : Vector2, end : Vector2, duration : float, trans : int = Tween.TRANS_LINEAR, easing : int = Tween.EASE_IN_OUT) -> void:
	var tween = create_tween().set_trans(trans).set_ease(easing)
	tween.tween_property(self, "global_position", end, duration).from(start)
	yield(tween, "finished")
