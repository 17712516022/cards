class_name AttributeDemon extends Node

var enemy : Card

func SetUp(context_enemy : Card) -> void:
	enemy = context_enemy

## 毒击：额外造成目标最大生命值 8% 的伤害
func on_attack(target: Card) -> void:
	if not is_instance_valid(target):
		return
	var poison : float = target.card_resource.health * 0.08
	if poison > 0.0:
		target.take_damage(poison)
