## 无属性杀手 — 攻击者对无属性(NO)敌人造成额外伤害
## 注意：这不是施加给目标的 debuff，而是攻击者自身的被动效果
## 在 do_attack 中，检测到目标属性为 NO 时，伤害 × killer_mutipler
class_name NoAttributeKiller extends Node2D

var card : Card
## 受伤倍率放大系数（默认 3 倍）
@export var killer_mutipler : float = 3.0

## 保存激活前的 noattack_multiplier，用于反激活时恢复
var _original_multiplier: float = 1.0

## 激活：设置攻击者卡牌对无属性目标的伤害倍率
## 注意：context_card 应始终为攻击者自身，因为此效果不在 trigger_attack_effects 中传递给目标
func activate(context_card: Card) -> void:
	if not is_instance_valid(context_card):
		return
	card = context_card
	_original_multiplier = card.noattack_multiplier
	card.noattack_multiplier = killer_mutipler

## 反激活：恢复倍率
func deactivate() -> void:
	if is_instance_valid(card):
		card.noattack_multiplier = _original_multiplier

func ball_activate(ball_res : SpecialEffectBall,context_card : Card) -> void :
	activate(context_card)
