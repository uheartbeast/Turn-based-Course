extends AI

func _select_battle_action(class_stats : ClassStats) -> BattleAction:
	var actions = class_stats.battle_actions
	if actions.empty(): return null
	actions.shuffle()
	return actions.front()
