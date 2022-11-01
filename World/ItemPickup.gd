extends Interactable

var inventory : Inventory = ReferenceStash.inventory

export(Resource) var item : Resource setget set_item

onready var sprite := $Sprite

func set_item(value : Item) -> void:
	item = value
	call_deferred("set_sprite_texture", item)

func set_sprite_texture(item : Item) -> void:
	if not sprite: return
	sprite.texture = item.overworld_sprite

func _run_interaction() -> void:
	inventory.add_item(item)
	Events.emit_signal("request_show_message", "You found a " + str(item.name) + ".")
	queue_free()
