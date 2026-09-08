class_name CardEffectApplier extends Node

var card_res : Resource

func SetUp(context_card_res : Resource) -> void :
	card_res = context_card_res

## 攻击命中时：根据攻击者 special_effects，在目标身上 apply 对应效果
## target_attribute 过滤：空数组 → 对所有敌人有效；非空时目标只需匹配其中任意一个属性
func trigger_attack_effects(target: Card, effect: Array) -> void:
	if not is_instance_valid(target):
		return
	# 检查属性是否匹配：目标必须持有 target_attribute 中至少一个属性
	if "target_attribute" in card_res and card_res.target_attribute:
		# card_resource.target_attribute 现在是 Array[ATTRIBUTE]
		var attrs: Array = card_res.target_attribute
		if not attrs is Array or attrs.is_empty():
			pass  # 空数组 → 所有敌人都匹配
		else:
			# 直接用目标卡牌的 attribute 字段匹配，而非寻找 SquadEnemy 下的节点名
			if not attrs.has(target.card_resource.attribute):
				return  # 目标不持有任何匹配属性，跳过效果
	# NoAttributeKiller 不施加给目标（它是攻击者的被动，在 do_attack 中处理）
	var filtered: Array = []
	for e in effect:
		if e != DataManager.SPECIALEFFECTS.NOATTRIBUTEKILLER:
			filtered.append(e)
	if not filtered.is_empty():
		target.special_effects.apply(card_res,filtered)

## 对目标应用所有装备球的效果（仅玩家卡牌有此字段）
## ◆ 大部分球：施加到目标身上（如破盾、时停）
## ◆ NoAttributeKiller：施加到攻击者自身（提高攻击者对无属性敌人的伤害倍率）
func apply_ball_effects(attacker: Card, target: Card) -> void:
	if not is_instance_valid(target):
		return
	if not "equipped_balls" in card_res:
		return
	for ball in card_res.equipped_balls:
		# 属性不匹配 → 跳过（如钢铁杀手球对僵尸敌人无效）
		if target.card_resource.attribute != ball.target_attribute:
			continue
		if ball.effect == DataManager.SPECIALEFFECTS.NOATTRIBUTEKILLER:
			# 无属性杀手：效果应作用于攻击者自身
			attacker.special_effects.ball_apply(ball, attacker)
		else:
			target.special_effects.ball_apply(ball, target)
