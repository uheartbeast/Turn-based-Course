extends Projectile

onready var animated_sprite := $AnimatedSprite
onready var flame := $Flame
onready var explosion := $Explosion
onready var fire_impact_sound := $FireImpactSound

func _animate_collision() -> void:
	fire_impact_sound.play()
	animated_sprite.hide()
	flame.hide()
	explosion.emitting = true
	while explosion.emitting == true:
		yield(get_tree(), "idle_frame")
	emit_signal("collision_animation_finished")
