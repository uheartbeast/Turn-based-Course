extends Node2D

var turnManager : TurnManager = ReferenceStash.turnManager

onready var player_battle_unit = $PlayerPosition/PlayerBattleUnit
onready var enemy_battle_unit = $EnemyPosition/EnemyBattleUnit
onready var animation_player = $AnimationPlayer
onready var timer = $Timer

func _ready() -> void:
	yield(animation_player, "animation_finished")
	turnManager.connect("ally_turn_started", self, "_on_ally_turn_started")
	turnManager.connect("enemy_turn_started", self, "_on_enemy_turn_started")
	turnManager.start()

func _unhandled_input(event : InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		SceneStack.pop()

func _on_ally_turn_started() -> void:
	print("Ally turn started")
	player_battle_unit.melee_attack()
	timer.start(1.0)
	yield(timer, "timeout")
	turnManager.advance_turn()

func _on_enemy_turn_started() -> void:
	print("Enemy turn started")
	enemy_battle_unit.melee_attack()
	timer.start(1.0)
	yield(timer, "timeout")
	turnManager.advance_turn()
