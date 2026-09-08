## 天使杀手特殊效果 — 无视天使属性随机增益
## 效果：目标被标记后，天使敌人的随机增益效果不会触发
class_name AngelKiller extends Node2D

var card : Card

## 激活：标记目标，使其免疫天使增益
func activate(context_card: Card) -> void:
	if not is_instance_valid(context_card):
		return
	card = context_card
	card.ignore_angel_effect = true

## 反激活：清除标记，恶魔毒击恢复正常
func deactivate() -> void:
	if is_instance_valid(card):
		card.ignore_angel_effect = false

func ball_activate(ball_res : SpecialEffectBall,context_card : Card) -> void :
	activate(context_card)
