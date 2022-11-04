extends Area2D
class_name Door

onready var drop_point := $DropPoint

export(String, FILE, "*.tscn") var new_area
export(int, 32) var connection
export(bool) var door_sound_effect := false
