extends Interactable

var inventory : Inventory = ReferenceStash.inventory

export(Resource) var item : Resource setget set_item

onready var sprite := $Sprite
onready var pickup_sound := $OutliveParent/PickupSound
onready var id := WorldStash.get_id(self)

func _ready() -> void:
	if WorldStash.retrieve(id, "freed"):
		queue_free()

func set_item(value : Item) -> void:
	item = value
	call_deferred("set_sprite_texture", item)

func set_sprite_texture(item : Item) -> void:
	if not sprite: return
	sprite.texture = item.overworld_sprite

func _run_interaction() -> void:
	inventory.add_item(item)
	pickup_sound.play()
	Events.emit_signal("request_show_message", "You found a " + str(item.name) + ".")
	WorldStash.stash(id, "freed", true)
	queue_free()
