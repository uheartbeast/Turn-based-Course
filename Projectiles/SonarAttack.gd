extends Projectile

onready var animation_player := $AnimationPlayer
onready var sonar_impact_sound := $SonarImpactSound

func _animate_collision() -> void:
	sonar_impact_sound.play()
	animation_player.play("End")
	yield(animation_player, "animation_finished")
	emit_signal("collision_animation_finished")

func _on_AnimationPlayer_animation_finished(animation_name : String) -> void:
	if animation_name != "Start": return
	animation_player.play("Repeat")

