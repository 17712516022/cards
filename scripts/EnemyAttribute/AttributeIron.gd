class_name AttributeIron extends Node

var enemy : Card
var shield: float
var max_shield: float

func SetUp(context_enemy : Card) -> void:
	enemy = context_enemy
	max_shield = enemy.card_resource.health * 3.0
	shield = max_shield

## 用盾吸收伤害，返回穿透盾的剩余伤害
func absorb_damage(amount: float) -> float:
	if shield <= 0.0:
		return amount
	if shield >= amount:
		shield -= amount
		return 0.0
	var remaining := amount - shield
	shield = 0.0
	return remaining
