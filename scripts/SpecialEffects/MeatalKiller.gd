## 钢铁杀手特殊效果 — 无视钢铁属性护盾
class_name MetalKiller extends Node2D

var card : Card

func activate(context_card: Card) -> void:
	if not is_instance_valid(context_card):
		return
	# 钢铁杀手核心：标记目标，使其 take_damage 时跳过 AttributeManager._shield_absorb_damage
	card = context_card
	card.ignore_iron_shield = true

func deactivate() -> void:
	if is_instance_valid(card):
		card.ignore_iron_shield = false

func ball_activate(ball_res : SpecialEffectBall,context_card : Card) -> void :
	activate(context_card)
