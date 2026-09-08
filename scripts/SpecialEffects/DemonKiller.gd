## 恶魔杀手特殊效果 — 无视恶魔属性毒击
## 效果：目标被标记后，恶魔敌人的 on_attack 毒伤（8%最大生命值）不会触发
class_name DemonKiller extends Node2D

var card : Card

## 激活：标记目标，使其免疫恶魔毒击
func activate(context_card: Card) -> void:
	if not is_instance_valid(context_card):
		return
	card = context_card
	card.ignore_demon_poison = true

## 反激活：清除标记，恶魔毒击恢复正常
func deactivate() -> void:
	if is_instance_valid(card):
		card.ignore_demon_poison = false

func ball_activate(_ball_res : SpecialEffectBall,context_card : Card) -> void :
	activate(context_card)
