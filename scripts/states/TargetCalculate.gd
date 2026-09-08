class_name TargetCalculate extends Node

var enemies_in_range: Array[Node2D] = []
var card : Card

func SetUp(context_card : Card) -> void:
	card = context_card

## 复活中的僵尸不算目标（列表成员关系保持纯几何判定，此处只做"可否被攻击"过滤）
static func _is_targetable(body: Node2D) -> bool:
	return not (body is Card and body.is_reviving)

## 范围内是否存在可攻击的敌人（排除复活中的僵尸）
func has_targetable_enemies() -> bool:
	for enemy in enemies_in_range:
		if _is_targetable(enemy):
			return true
	return false

## 是否有士兵类型敌人在范围内（用于决定是否停止移动） 
func has_soldier_enemies() -> bool:
	for enemy in enemies_in_range:
		if not _is_targetable(enemy):
			continue
		if enemy is Card and enemy.card_resource is CardResource and enemy.card_resource.type == DataManager.PLAYERTYPE.WALKABLE:
			return true
	return false

func add_enemy(body: Node2D) -> void:
	if not body.has_method("take_damage"):
		return
	if not card._is_valid_target(body):
		return
	if body in enemies_in_range:   
		return
	enemies_in_range.append(body)

func remove_enemy(body: Node2D) -> void:
	enemies_in_range.erase(body)

func clean_enemies() -> void:
	for i in range(enemies_in_range.size() - 1, -1, -1):
		var enemy = enemies_in_range[i]
		if not is_instance_valid(enemy) or not card.hit_box.overlaps_body(enemy):
			enemies_in_range.remove_at(i)
