extends Node2D

const ZOOM_IN = Vector2(0.75, 0.75)
const ZOOM_DEFAULT = Vector2.ONE

var turnManager : TurnManager = ReferenceStash.turnManager
var asyncTurnPool : AsyncTurnPool = ReferenceStash.asyncTurnPool

var ai : AI

onready var player_battle_unit := $PlayerPosition/PlayerBattleUnit
onready var enemy_battle_unit := $EnemyPosition/EnemyBattleUnit
onready var animation_player := $AnimationPlayer
onready var timer := $Timer
onready var player_battle_unit_info := $BattleUI/PlayerBattleUnitInfo
onready var enemy_battle_unit_info := $BattleUI/EnemyBattleUnitInfo
onready var level_up_ui := $"%LevelUpUI"
onready var battle_menu_manager := $"%BattleMenuManager"
onready var battle_camera := $BattleCamera
onready var level_up_sound := $LevelUpSound

onready var center_position : Vector2 = $CenterRoot/CenterPoint.rect_global_position
onready var enemy_camera_position : Vector2 = get_battle_unit_camera_position(enemy_battle_unit)
onready var player_camera_position : Vector2 = get_battle_unit_camera_position(player_battle_unit)

func _ready() -> void:
	MusicPlayer.push_song(MusicPlayer.battle_music)
	var encounter_class : ClassStats = ReferenceStash.encounter_class
	if encounter_class is ClassStats:
		enemy_battle_unit.stats = encounter_class.duplicate()
	player_battle_unit_info.stats = player_battle_unit.stats
	enemy_battle_unit_info.stats = enemy_battle_unit.stats
	assert(enemy_battle_unit.stats.ai is Script)
	ai = enemy_battle_unit.stats.ai.new()
	add_child(ai)
	yield(animation_player, "animation_finished")
	turnManager.connect("ally_turn_started", self, "_on_ally_turn_started")
	turnManager.connect("enemy_turn_started", self, "_on_enemy_turn_started")
	turnManager.start()
	asyncTurnPool.connect("turn_over", self, "_on_async_turn_pool_turn_over")

func get_battle_unit_camera_position(battle_unit : BattleUnit) -> Vector2:
	var final_position := Vector2()
	var start = Vector2(battle_unit.global_position.x, center_position.y)
	final_position = start.move_toward(center_position, 32)
	return final_position

func battle_won() -> void:
	ReferenceStash.inventory.add_item(load("res://Items/AppleItem.tres"))
	timer.start(0.5)
	yield(timer, "timeout")
	var previous_level : int = player_battle_unit.stats.level
	player_battle_unit.stats.experience += 105
	if player_battle_unit.stats.level > previous_level:
		level_up_sound.play()
		yield(level_up_ui.level_up(), "completed")
	timer.start(0.5)
	yield(timer, "timeout")

func exit_battle() -> void:
	MusicPlayer.pop_song()
	yield(Transition.fade_to_color(Color.black), "completed")
	Transition.fade_from_color(Color.black)
	SceneStack.pop()

func _on_ally_turn_started() -> void:
	if not is_instance_valid(player_battle_unit):
		timer.start(1.0)
		yield(timer, "timeout")
		get_tree().quit()
		return
	
	yield(battle_menu_manager.show_battle_menu(), "completed")
	var selected_resource : Resource = yield(battle_menu_manager, "battle_menu_resource_selected")
	
	if selected_resource is MeleeBattleAction:
		battle_camera.focus_target(enemy_camera_position, ZOOM_IN)
		player_battle_unit.melee_attack(enemy_battle_unit, selected_resource)
	elif selected_resource is RangedBattleAction:
		player_battle_unit.ranged_attack(enemy_battle_unit, selected_resource)
	elif selected_resource.name == "Defend":
		asyncTurnPool.add(self)
		player_battle_unit.defend = true
		timer.start(1.0)
		yield(timer, "timeout")
		asyncTurnPool.remove(self)
	elif selected_resource is Item:
		player_battle_unit.use_item(player_battle_unit, selected_resource)
	elif selected_resource.name == "Run":
		exit_battle()

func _on_enemy_turn_started() -> void:
	if not is_instance_valid(enemy_battle_unit) or enemy_battle_unit.is_queued_for_deletion():
		yield(battle_won(), "completed")
		exit_battle()
		return
	
	var battle_action = ai._select_battle_action(enemy_battle_unit.stats)
	
	if battle_action is MeleeBattleAction:
		battle_camera.focus_target(player_camera_position, ZOOM_IN)
		enemy_battle_unit.melee_attack(player_battle_unit, battle_action)
	elif battle_action is RangedBattleAction:
		enemy_battle_unit.ranged_attack(player_battle_unit, battle_action)
	elif battle_action.name == "Defend":
		asyncTurnPool.add(self)
		enemy_battle_unit.defend = true
		timer.start(1.0)
		yield(timer, "timeout")
		asyncTurnPool.remove(self)

func _on_async_turn_pool_turn_over() -> void:
	yield(battle_camera.focus_target(center_position, ZOOM_DEFAULT), "completed")
	turnManager.advance_turn()
