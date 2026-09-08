# ============================================================
#  ManaManager — 法力资源管理器（Autoload）
#  管理法力值 / 消耗检查 / 自动回复
#  通过 EventBus.mana_changed 信号通知 UI 更新
# ============================================================
extends Node

# ── 属性 ──

## 当前法力（浮点精度，信号发送时取整）
var current_mana: float = 100.0

## 最大法力上限
@export var max_mana: int = 200

## 初始法力
@export var starting_mana: int = 100

## 每秒回复量
@export var regen_per_second: float = 6.0

# ── 生命周期 ──
func _ready() -> void:
	current_mana = float(starting_mana)
	# 显式启用物理处理，确保 _physics_process 被调用
	set_physics_process(true)
	# 延迟一帧再发信号，确保 UI 节点已就绪并完成连接
	await get_tree().process_frame
	_emit_changed()

## 每帧自动回复，整数变化时发信号
func _physics_process(delta: float) -> void:
	if current_mana < float(max_mana):
		var before := int(current_mana)
		current_mana = minf(current_mana + regen_per_second * delta, float(max_mana))
		if int(current_mana) != before:
			_emit_changed()

# ── 公开 API ──

## 当前法力（取整）
func get_mana() -> int:
	return int(current_mana)

## 是否够法力
func can_afford(cost: int) -> bool:
	return int(current_mana) >= cost

## 消耗法力。成功 true，不够 false
func spend_mana(cost: int) -> bool:
	if not can_afford(cost):
		return false
	current_mana -= float(cost)
	_emit_changed()
	return true

## 恢复法力（药水、技能增益）
func recover_mana(amount: float) -> void:
	current_mana = minf(current_mana + amount, float(max_mana))
	_emit_changed()
# ── 内部 ──

func _emit_changed() -> void:
	EventBus.mana_changed.emit(int(current_mana), max_mana)
