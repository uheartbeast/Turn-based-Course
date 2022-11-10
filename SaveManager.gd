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
