extends Node2D

var turnManager : TurnManager = ReferenceStash.turnManager

onready var player_battle_unit := $PlayerPosition/PlayerBattleUnit
onready var enemy_battle_unit := $EnemyPosition/EnemyBattleUnit
onready var animation_player := $AnimationPlayer
onready var timer := $Timer

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
	yield(player_battle_unit.melee_attack(enemy_battle_unit), "completed")
	turnManager.advance_turn()

func _on_enemy_turn_started() -> void:
	print("Enemy turn started")
	yield(enemy_battle_unit.melee_attack(player_battle_unit), "completed")
	turnManager.advance_turn()
