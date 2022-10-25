extends Node

var turnManager := TurnManager.new()
var asyncTurnPool := AsyncTurnPool.new()

var elizabethStats : PlayerClassStats = load("res://ClassStats/ElizabethClassStats.tres")
var inventory : Inventory = load("res://Items/Inventory.tres")
