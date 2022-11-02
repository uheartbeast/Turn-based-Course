extends Interactable

var inventory : Inventory = ReferenceStash.inventory

export(Resource) var item : Resource

onready var id := WorldStash.get_id(self)

func _ready() -> void:
	if WorldStash.retrieve(id, "item") == "none":
		item = null

func _run_interaction() -> void:
	if item is Item:
		inventory.add_item(item)
		Events.emit_signal("request_show_message", "You found a " + str(item.name) + ".")
		item = null
		WorldStash.stash(id, "item", "none")
	else:
		Events.emit_signal("request_show_message", "It's just a barrel...")
