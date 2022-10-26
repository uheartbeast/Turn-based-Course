extends BattleAction
class_name DamageBattleAction

enum Type {MELEE, RANGED}

export(Type) var type := Type.MELEE
export(int) var damage := 5
