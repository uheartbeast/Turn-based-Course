extends ScrollList

var inventory : Inventory = ReferenceStash.inventory

func _ready() -> void:
	fill(inventory.items)
	inventory.connect("item_added", self, "_on_item_added")
	inventory.connect("item_changed", self, "_on_item_changed")
	inventory.connect("item_removed", self, "_on_item_removed")

func update_item_button_text(button: ResourceButton) -> void:
	button.text = button.resource.name

func _on_item_added(item_index : int, item : Item) -> void:
	var item_button : ResourceButton = add_resource_button()
	item_button.resource = item
	update_item_button_text(item_button)

func _on_item_changed(item_index : int, item : Item) -> void:
	var item_button : ResourceButton = button_container.get_child(item_index)
	item_button.resource = item
	update_item_button_text(item_button)

func _on_item_removed(item_index : int) -> void:
	var item_button : ResourceButton = button_container.get_child(item_index)
	item_button.queue_free()
	focus_nodes.remove(item_index)
