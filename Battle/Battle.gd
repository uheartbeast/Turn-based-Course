extends Node2D

onready var player_battle_unit = $PlayerPosition/PlayerBattleUnit
onready var enemy_battle_unit = $EnemyPosition/EnemyBattleUnit

func _ready() -> void:
	player_battle_unit.melee_attack()

func _unhandled_input(event : InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		SceneStack.pop()
