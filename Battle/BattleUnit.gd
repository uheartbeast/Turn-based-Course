extends Node2D
class_name BattleUnit

const ATTACK_OFFSET = 48

export(PackedScene) var battle_animations_scene

var battle_animations : BattleAnimations

onready var root_position := global_position

func _ready() -> void:
	if battle_animations_scene is PackedScene:
		battle_animations = battle_animations_scene.instance()
		add_child(battle_animations)

func melee_attack(target : Node2D) -> void:
	z_index = 10
	battle_animations.play("Approach")
	var target_position := target.global_position.move_toward(global_position, ATTACK_OFFSET)
	var animation_duration := battle_animations.get_current_animation_length()
	interpolate_position(global_position, target_position, animation_duration)
	yield(battle_animations, "animation_finished")
	
	print("Attack")
	
	battle_animations.play("Melee")
	yield(battle_animations, "animation_finished")
	
	battle_animations.play("Return")
	animation_duration = battle_animations.get_current_animation_length()
	interpolate_position(global_position, root_position, animation_duration)
	yield(battle_animations, "animation_finished")
	
	battle_animations.play("Idle")
	z_index = 0

func interpolate_position(start : Vector2, end : Vector2, duration : float, trans : int = Tween.TRANS_LINEAR, easing : int = Tween.EASE_IN_OUT) -> void:
	var tween = create_tween().set_trans(trans).set_ease(easing)
	tween.tween_property(self, "global_position", end, duration).from(start)
	yield(tween, "finished")
