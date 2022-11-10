extends Node

const TEST_PATH := "res://save.json"
const SAVE_PATH := "user://save.json"

var file := File.new()

func save_game() -> void:
	if file.open(TEST_PATH, File.WRITE) != OK: return
	var stats : PlayerClassStats = ReferenceStash.elizabethStats
	var inventory : Inventory = ReferenceStash.inventory
	var world_data : Dictionary = WorldStash.data
	var player_global_position : Vector2 = ReferenceStash.player.global_position
	
	var save_data : Dictionary = {
		"current_scene" : get_tree().current_scene.filename,
		"player" : {
			"x" : player_global_position.x,
			"y" : player_global_position.y,
		},
		"stats" : {
			"level" : stats.level,
			"health" : stats.health,
			"experience" : stats.experience,
		},
		"inventory" : [],
		"world_data" : world_data,
	}
	
	for item in inventory.items:
		save_data.inventory.append({
			"resource_path" : item.resource_path,
			"amount" : item.amount,
		})
	
	var data_string := JSON.print(save_data)
	print(data_string)
	file.store_string(data_string)
	file.close()

func load_game() -> void:
	if file.open(TEST_PATH, File.READ) != OK: return
	var data_string := file.get_as_text()
	file.close()
	
	var load_data : Dictionary = JSON.parse(data_string).result
	WorldStash.data = load_data.world_data
	
	var stats : PlayerClassStats = ReferenceStash.elizabethStats
	stats.level = load_data.stats.level
	stats.health = load_data.stats.health
	stats.experience = load_data.stats.experience
	
	var inventory : Inventory = ReferenceStash.inventory
	inventory.items.clear()
	for item_data in load_data.inventory:
		var item : Item = load(item_data.resource_path)
		inventory.add_item(item, item_data.amount)
	
	if not ReferenceStash.player is KinematicBody2D:
		var player = load("res://World/OverworldPlayer.tscn").instance()
		LevelSwapper.player = player
		ReferenceStash.player = player
	
	var player = ReferenceStash.player
	player.last_door_connect = -1
	yield(Transition.fade_to_color(Color.black), "completed")
	LevelSwapper.level_swap(player, load_data.current_scene)
	player.global_position = Vector2(load_data.player.x, load_data.player.y)
	Transition.fade_from_color(Color.black)
