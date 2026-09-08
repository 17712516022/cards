# 全局游戏数据 — 跨场景共享
extends Node

const RECOVER_MANA : float = 10.0

## 玩家选定的卡组（在 DeckEditPanel 中设置，map 中用）
var deck: Array = []

## 玩家收集的特殊效果球背包
var collected_balls: Array[SpecialEffectBall] = []

func _ready() -> void:
	EventBus.enemy_dead.connect(_on_enemy_dead)


## 保存卡组（DeckEditPanel 确认时调用）
func save_deck(card_keys: Array) -> void:
	deck = card_keys.duplicate()

## 获取卡组
func get_deck() -> Array:
	return deck

## 收集一个球到背包
func collect_ball(ball: SpecialEffectBall) -> void:
	collected_balls.append(ball)

## 从背包移除一个球
func remove_ball(ball: SpecialEffectBall) -> void:
	var idx := collected_balls.find(ball)
	if idx >= 0:
		collected_balls.remove_at(idx)

## 获取所有收集的球
func get_collected_balls() -> Array[SpecialEffectBall]:
	return collected_balls

func _on_enemy_dead() -> void:
	ManaManager.recover_mana(RECOVER_MANA)
