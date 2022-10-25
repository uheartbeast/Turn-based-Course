extends Resource
class_name Inventory

export(Array, Resource) var items : Array = []

signal item_added(item_inex, item)
signal item_changed(item_index, item)
signal item_removed(item_index)

func add_item(item : Item, amount : int = 1) -> void:
	var item_index := items.find(item)
	if item_index == -1:
		items.append(item)
		item.amount = amount
		emit_signal("item_added", items.size()-1, item)
	else:
		items[item_index].amount += amount
		emit_signal("item_changed", item_index, item)
