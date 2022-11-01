extends Node

var player : KinematicBody2D

func stash_player(player_to_stash : KinematicBody2D) -> void:
	player = player_to_stash
	player.get_parent().remove_child(player)

func level_swap(player_to_stash : KinematicBody2D, new_level_string : String) -> void:
	stash_player(player_to_stash)
	get_tree().change_scene(new_level_string)
	drop_player()

func drop_player() -> void:
	yield(get_tree(), "idle_frame")
	var parent := get_tree().current_scene
	parent.add_child(player)
	player.owner = parent
	for door in get_tree().get_nodes_in_group("Doors"):
		if door.connection != player.last_door_connection: continue
		player.global_position = door.drop_point.global_position
