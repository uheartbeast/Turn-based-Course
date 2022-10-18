extends KinematicBody2D

const WALK_SPEED = 80

var velocity := Vector2.ZERO

func _physics_process(delta : float) -> void:
	var input_vector = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_vector * WALK_SPEED
	move_and_slide(velocity)
