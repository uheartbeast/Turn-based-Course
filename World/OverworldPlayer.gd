extends KinematicBody2D

const WALK_SPEED := 80
const MAX_ENCOUNTER_METER := 100
const MIN_ENCOUNTER_CHANCE := 0.1
const ENCOUNTER_METER_REDUCTION_AMOUNT := 75

var velocity := Vector2.ZERO
var encounter_meter := MAX_ENCOUNTER_METER
var encounter_chance := MIN_ENCOUNTER_CHANCE

onready var animated_sprite := $AnimatedSprite
onready var interactable_detector := $InteractableDetector

func _ready() -> void:
	interactable_detector.rotation = Vector2.DOWN.angle()

func _physics_process(delta : float) -> void:
	var input_vector = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_vector * WALK_SPEED
	move_and_slide(velocity)
	
	if is_moving():
		animate_walk()
		interactable_detector.rotation = velocity.angle()
		encounter_check(delta)
	else:
		animate_idle()

func _unhandled_input(event : InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		var interactables : Array = interactable_detector.get_overlapping_bodies()
		for interactable in interactables:
			if not interactable is Interactable: continue
			interactable._run_interaction()
			get_tree().set_input_as_handled()
	
	if event.is_action_pressed("ui_cancel"):
		Events.emit_signal("request_show_overworld_menu")

func is_moving() -> bool:
	return velocity != Vector2.ZERO

func encounter() -> void:
	var random_encounters = ReferenceStash.random_encounters
	if random_encounters.empty(): return
	random_encounters.shuffle()
	ReferenceStash.encounter_class = random_encounters.front()
	SceneStack.push("res://Battle/Battle.tscn")

func encounter_check(delta : float) -> void:
	encounter_meter -= ENCOUNTER_METER_REDUCTION_AMOUNT * delta
	if encounter_meter <= 0:
		encounter_meter = MAX_ENCOUNTER_METER
		if Math.chance(encounter_chance):
			encounter_chance = MIN_ENCOUNTER_CHANCE
			encounter()
		else:
			encounter_chance = min(encounter_chance + 0.1, 1.0)

func animate_walk() -> void:
	var angle : float = velocity.angle()
	var angle_in_degree : float = rad2deg(angle)
	var rounded_angle : int = int(round(angle_in_degree / 45) * 45)
	match rounded_angle:
		-135, 180, 135: animated_sprite.animation = "WalkLeft"
		0, -45, 45: animated_sprite.animation = "WalkRight"
		-90: animated_sprite.animation = "WalkUp"
		90: animated_sprite.animation = "WalkDown"

func animate_idle() -> void:
	match animated_sprite.animation:
		"WalkLeft": animated_sprite.animation = "IdleLeft"
		"WalkRight": animated_sprite.animation = "IdleRight"
		"WalkUp": animated_sprite.animation = "IdleUp"
		"WalkDown": animated_sprite.animation = "IdleDown"
