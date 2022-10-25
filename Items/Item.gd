extends Resource
class_name Item

export(String) var name : String
export(String, MULTILINE) var description : String
export(int) var amount = 1 setget set_amount

func set_amount(value : int) -> void:
	amount = max(0, value)
