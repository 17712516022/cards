## 魔法卡：拖到目标上释放一次性效果
class_name CardUIMagic extends CardUI

## 魔法卡默认索敌半径（当 card_res.attack_range 为空/0 时使用）
const DEFAULT_ATTACK_RANGE := 150.0

func _is_placement_valid() -> bool:
	# 只在鼠标下方有敌人才算有效放置位
	return true

func _end_drag() -> void:
	if not ManaManager.spend_mana(card_res.mana):
		CarduiDragger._cancel_drag()
		return
	
	var drop_pos := get_global_mouse_position()
	var atk_range := _get_attack_range()
	
	# 实例化魔法单位
	var new_card: Card = CARD_SCENE.instantiate()
	var dup := card_res.duplicate()
	dup.equipped_balls = card_res.equipped_balls.duplicate()
	new_card.card_resource = dup
	
	var squad: Node2D = Squad.instantiate()
	new_card.add_child(squad)
	
	# 挂到场景根节点下（Map），避免被 soldier_spawn 的进度系统接管
	var map: Map = get_tree().current_scene
	map.add_child(new_card)
	new_card.global_position = drop_pos
	
	# 等待一帧：保证 new_card._ready() 执行完毕（hit_box / 状态机 / TargetCalculater 初始化）
	await get_tree().process_frame
	
	if not is_instance_valid(new_card):
		return
	
	# 将落点攻击范围内的敌人填入 TargetCalculater
	# 注意：CardStateAttacking.enter() 会调用 clean_enemies()，它用 hit_box.overlaps_body() 重校验
	# Area2D 入树后立即生效，overlaps_body 对范围内敌人返回 true，不会被误删
	var r2 := atk_range * atk_range
	for enemy in _get_all_enemy_cards():
		if enemy.global_position.distance_squared_to(drop_pos) <= r2:
			new_card.card_state_machine.TargetCalculater.add_enemy(enemy)
	
	CarduiDragger.cleanup()
	play_dissolve_and_free()

## 获取攻击范围（优先用卡牌配置，兜底用默认值）
func _get_attack_range() -> float:
	if card_res.attack_range > 0.0:
		return card_res.attack_range
	return DEFAULT_ATTACK_RANGE

## 落点附近是否有敌军
func _has_enemy_near(pos: Vector2) -> bool:
	var r2 := _get_attack_range() * _get_attack_range()
	for enemy in _get_all_enemy_cards():
		if enemy.global_position.distance_squared_to(pos) <= r2:
			return true
	return false

## 递归收集所有敌方 Card（判定条件：拥有 SquadEnemy 子节点）
func _get_all_enemy_cards() -> Array[Card]:
	var result: Array[Card] = []
	var map: Map = get_tree().current_scene
	if not map:
		return result
	_collect_enemy_cards_recursive(map, result)
	return result

func _collect_enemy_cards_recursive(node: Node, out: Array[Card]) -> void:
	if node is Card and node.has_node("SquadEnemy"):
		out.append(node)
	for child in node.get_children():
		_collect_enemy_cards_recursive(child, out)
