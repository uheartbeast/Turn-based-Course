extends YSort

func _ready() -> void:
	if MusicPlayer.stack.has(MusicPlayer.town_music): return
	MusicPlayer.push_song(MusicPlayer.town_music)
