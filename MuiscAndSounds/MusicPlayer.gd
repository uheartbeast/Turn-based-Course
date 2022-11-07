extends Node

var stack := []

onready var town_music = $TownMusic
onready var battle_music = $BattleMusic

func push_song(song : AudioStreamPlayer) -> void:
	if not stack.empty(): stack.back().stream_paused = true
	stack.append(song)
	song.play()

func pop_song() -> void:
	if stack.empty(): return
	var current_song : AudioStreamPlayer = stack.pop_back()
	var volume_fade = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	volume_fade.tween_property(current_song, "volume_db", -50.0, 0.25).from_current()
	yield(volume_fade, "finished")
	current_song.stop()
	current_song.volume_db = 0.0
	var last_song : AudioStreamPlayer = stack.back()
	last_song.volume_db = -50.0
	last_song.stream_paused = false
	var volume_rise = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	volume_rise.tween_property(last_song, "volume_db", 0.0, 1.0).from_current()
	
