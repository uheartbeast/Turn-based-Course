extends Node
class_name Math

static func chance(percent : float) -> bool:
	return randf() <= percent
