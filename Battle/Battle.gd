extends Node2D

var turnManager : TurnManager = ReferenceStash.turnManager
var asyncTurnPool : AsyncTurnPool = ReferenceStash.asyncTurnPool

onready var player_battle_unit := $PlayerPosition/PlayerBattleUnit
onready var enemy_battle_unit := $EnemyPosition/EnemyBattleUnit
onready var animation_player := $AnimationPlayer
onready var timer := $Timer
onready var player_battle_unit_info := $BattleUI/PlayerBattleUnitInfo
onready var enemy_battle_unit_info := $BattleUI/EnemyBattleUnitInfo

func _ready() -> void:
	player_battle_unit_info.stats = player_battle_unit.stats
	enemy_battle_unit_info.stats = enemy_battle_unit.stats
	yield(animation_player, "animation_finished")
	turnManager.connect("ally_turn_started", self, "_on_ally_turn_started")
	turnManager.connect("enemy_turn_started", self, "_on_enemy_turn_started")
	turnManager.start()
	asyncTurnPool.connect("turn_over", self, "_on_async_turn_pool_turn_over")

func _unhandled_input(event : InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		SceneStack.pop()

func exit_battle() -> void:
	timer.start(1.0)
	yield(timer, "timeout")
	SceneStack.pop()

func _on_ally_turn_started() -> void:
	if not is_instance_valid(player_battle_unit):
		timer.start(1.0)
		yield(timer, "timeout")
		get_tree().quit()
		return
	player_battle_unit.melee_attack(enemy_battle_unit)

func _on_enemy_turn_started() -> void:
	if not is_instance_valid(enemy_battle_unit) or enemy_battle_unit.is_queued_for_deletion():
		exit_battle()
		return
	enemy_battle_unit.melee_attack(player_battle_unit)

func _on_async_turn_pool_turn_over() -> void:
	turnManager.advance_turn()
