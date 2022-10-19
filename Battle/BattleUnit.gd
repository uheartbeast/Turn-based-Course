extends Node2D
class_name BattleUnit

export(PackedScene) var battle_animations_scene

var battle_animations : BattleAnimations

func _ready() -> void:
	if battle_animations_scene is PackedScene:
		battle_animations = battle_animations_scene.instance()
		add_child(battle_animations)

func melee_attack() -> void:
	print("Attack")
