extends Sprite
class_name BattleAnimations

onready var animation_player := $AnimationPlayer

signal animation_finished

func _ready() -> void:
	animation_player.connect("animation_finished", self, "emmit_signal", ["animation_finished"])
	
func get_current_animation_length() -> float:
	return animation_player.current_animation_length / animation_player.playback_speed

func play(animation_name : String) -> void:
	assert(animation_player.has_animation(animation_name))
	animation_player.play(animation_name)
