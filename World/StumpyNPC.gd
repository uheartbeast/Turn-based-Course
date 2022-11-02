extends NPC

const ELIZABETH_CHARACTER : Character = preload("res://Characters/ElizabethCharacter.tres")
const APPLE_ITEM : Item = preload("res://Items/AppleItem.tres")

var inventory : Inventory = ReferenceStash.inventory

var has_apple := false

onready var id := WorldStash.get_id(self)

func _ready() -> void:
	if WorldStash.retrieve(id, "has_apple"):
		has_apple = true

func _run_interaction() -> void:
	if not has_apple:
		Events.emit_signal("request_show_dialog", "Aaaaaah! I have a head ache.", character)
		yield(Events, "dialog_finished")
		Events.emit_signal("request_show_dialog", "Do you have an apple I can eat?", character)
		yield(Events, "dialog_finished")
		
		var apple = inventory.remove_item(APPLE_ITEM)
		
		if apple is Item:
			Events.emit_signal("request_show_dialog", "I do.", ELIZABETH_CHARACTER)
			yield(Events, "dialog_finished")
			Events.emit_signal("request_show_dialog", "Here it is.", ELIZABETH_CHARACTER)
			yield(Events, "dialog_finished")
			has_apple = true
			WorldStash.stash(id, "has_apple", true)
		else:
			Events.emit_signal("request_show_dialog", "I'll look around for you.", ELIZABETH_CHARACTER)
			yield(Events, "dialog_finished")
	
	if has_apple:
		Events.emit_signal("request_show_dialog", "I feel much better now.", character)
		yield(Events, "dialog_finished")
		Events.emit_signal("request_show_dialog", "Thank you.", character)
		yield(Events, "dialog_finished")
		Events.emit_signal("request_show_dialog", "You're welcome!", ELIZABETH_CHARACTER)
		yield(Events, "dialog_finished")
