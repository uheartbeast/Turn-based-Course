extends TextureRect

onready var decrease := $Decrease
onready var increase := $Increase
onready var actual := $Actual

signal animation_finished

var bar_value : float = 0.0

func _ready() -> void:
	set_bar(10, 12)

func set_bar(value : float, max_value : float) -> void:
	bar_value = (value / max_value) * 100.0
	decrease.value = bar_value
	increase.value = bar_value
	actual.value = bar_value
