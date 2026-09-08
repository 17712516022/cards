class_name AttributeAngel extends Node

var enemy : Card

const COUNT_OF_DEBUFF : int = 3

func SetUp(context_enemy : Card) -> void:
	enemy = context_enemy

## 攻击时随机激活目标身上的一个负面效果
func on_attack(res : Resource,target: Card) -> void:
	if not is_instance_valid(target):
		return
	var keys := target.special_effects.effects_dic.keys()
	if keys.is_empty():
		return
	var key = keys[randi() % COUNT_OF_DEBUFF]
	target.special_effects.effects_dic[key].activate(res,target)
