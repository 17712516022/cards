extends Node

## 尝试复活：委托给属性节点处理
func _try_revive(card_resource, enemysquad : SquadEnemy) -> bool:
	if not card_resource is EnemyCardResource:
		return false
	if card_resource.attribute != DataManager.ATTRIBUTE.ZOMBIN:
		return false   # ← 先筛掉非僵尸，避免拿错属性节点
	if not enemysquad:
		return false
	var zom : AttributeZombin = enemysquad.get_child(0)
	if not zom:
		return false
	return zom.try_revive()

## 盾吸伤：钢铁属性用盾吸收伤害，返回剩余伤害
func _shield_absorb_damage(card_resource, enemysquad : SquadEnemy, amount: float) -> float:
	if not card_resource is EnemyCardResource:
		return amount
	if card_resource.attribute != DataManager.ATTRIBUTE.IRON:
		return amount
	if not enemysquad:
		return amount
	var iron := enemysquad.get_child(0) as AttributeIron
	if not iron:
		return amount
	return iron.absorb_damage(amount)

## 天使攻击：随机激活目标身上一个负面效果
func _angel_activate_random_enemy_effect(card_resource, enemysquad: SquadEnemy, target: Card) -> void:
	if not card_resource is EnemyCardResource:
		return
	if card_resource.attribute != DataManager.ATTRIBUTE.ANGEL:
		return
	if not enemysquad:
		return
	var angel := enemysquad.get_child(0) as AttributeAngel
	if not angel:
		return
	angel.on_attack(card_resource,target)

## 恶魔毒击：攻击附带目标最大生命值 5% 的额外伤害
func _demon_poison_attack(card_resource, enemysquad: SquadEnemy, target: Card) -> void:
	if not card_resource is EnemyCardResource:
		return
	if card_resource.attribute != DataManager.ATTRIBUTE.DEMON:
		return
	if not enemysquad:
		return
	var demon := enemysquad.get_child(0) as AttributeDemon
	if not demon:
		return
	demon.on_attack(target)
