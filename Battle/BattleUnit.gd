extends Node2D
class_name BattleUnit

const ATTACK_OFFSET = 48
const KNOCKBACK_AMOUNT = 24

var asyncTurnPool : AsyncTurnPool = ReferenceStash.asyncTurnPool

export(Resource) var stats setget set_stats

var battle_animations : BattleAnimations
var defend : bool = false setget set_defend

onready var root_position := global_position
onready var battle_shield := $BattleShield
onready var impact_sound := $ImpactSound
onready var impact_defend := $ImpactDefendSound
onready var defend_sound := $DefendSound
onready var heal_sound := $HealSound

func set_stats(value : ClassStats) -> void:
	stats = value
	if not stats is ClassStats: return
	if battle_animations is BattleAnimations: battle_animations.queue_free()
	battle_animations = stats.battle_animations.instance()
	add_child(battle_animations)

func set_defend(value : bool ) -> void:
	defend = value
	battle_shield.visible = defend
	if defend == true:
		defend_sound.play()

func melee_attack(target : BattleUnit, battle_action : MeleeBattleAction) -> void:
	asyncTurnPool.add(self)
	z_index = 10
	battle_animations.play("Approach")
	var target_position := target.global_position.move_toward(global_position, ATTACK_OFFSET)
	var animation_duration := battle_animations.get_current_animation_length()
	interpolate_position(global_position, target_position, animation_duration)
	yield(battle_animations, "animation_finished")
	
	deal_damage(target, battle_action)
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

func ranged_attack(target: BattleUnit, battle_action: RangedBattleAction) -> void:
	asyncTurnPool.add(self)
	battle_animations.play("RangedAnticipation")
	yield(battle_animations, "animation_finished")
	
	var projectile = battle_action.projectile.instance()
	add_child(projectile)
	projectile.global_position = battle_animations.get_emission_position()
	projectile.move_to(target)
	projectile.connect("contact", self, "ranged_attack_hit", [target, battle_action], CONNECT_ONESHOT)
	
	battle_animations.play("RangedRelease")
	yield(battle_animations, "animation_finished")
	battle_animations.play("Idle")
	asyncTurnPool.remove(self)

func use_item(target: BattleUnit, item: Item) -> void:
	asyncTurnPool.add(self)
	battle_animations.play("ItemAnticipation")
	yield(battle_animations, "animation_finished")
	stats.health += item.heal_amount
	heal_sound.play()
	battle_animations.play("ItemRelease")
	yield(battle_animations, "animation_finished")
	battle_animations.play("Idle")
	asyncTurnPool.remove(self)

func ranged_attack_hit(target : BattleUnit, battle_action: BattleAction) -> void:
	deal_damage(target, battle_action)
	target.take_hit(self)

func deal_damage(target: BattleUnit, battle_action : DamageBattleAction) -> void:
	var damage = ((stats.level*3 + (1-target.stats.defense * 0.05)) / 2) * ((stats.attack + battle_action.damage / 5) / 6)
	if target.defend:
		impact_defend.play()
		target.defend = false
		damage = round(damage / 2)
	else:
		impact_sound.play()
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
