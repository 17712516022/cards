class_name CardUIDragger extends Node2D

var _dragging: bool = false
var _local_offset: Vector2
var _hand_card: Node
var _cardui_was_top_level: bool
var _drag_start_time: int = 0          ## 拖拽开始时间戳（msec）
var _ui_layer: Node                    ## 拖入的 UI 层引用，用于恢复

const MIN_HOLD_MS := 60                ## 最少按住时间，防止单击误触

var cardui : CardUI

func SetUp(context_cardui : CardUI) -> void:
	cardui = context_cardui

func is_dragging() -> bool:
	return _dragging

func can_end_drag() -> bool:             ## 是否满足释放条件（按住超过最短时间）
	return _dragging and Time.get_ticks_msec() - _drag_start_time >= MIN_HOLD_MS

func get_drag_offset() -> Vector2:
	return _local_offset

func _start_drag() -> void:
	if _dragging:
		return
	_hand_card = cardui.get_parent()
	_local_offset = get_global_mouse_position() - global_position
	_dragging = true
	_drag_start_time = Time.get_ticks_msec()

	_ui_layer = _hand_card.get_parent().get_parent()

	# 1. CardUIDragger 移到 UI 层，避免被 CardUI 的 dissolve 一起销毁
	var saved_global := global_position
	cardui.remove_child(self)
	_ui_layer.add_child(self)
	global_position = saved_global
	position = get_global_mouse_position() - _local_offset

	# 2. CardUI 移到 UI 层，脱离手牌容器的排序/裁剪影响
	_cardui_was_top_level = cardui.top_level
	var cardui_global := cardui.global_position
	_hand_card.remove_child(cardui)
	_ui_layer.add_child(cardui)
	cardui.global_position = cardui_global

	# 3. 拖拽放大效果
	cardui.scale = Vector2(1.5, 1.5)

func _cancel_drag() -> void:
	# 恢复 CardUIDragger
	get_parent().remove_child(self)
	cardui.add_child(self)
	position = Vector2.ZERO                 # 归零！否则下次 _start_drag 的 _local_offset 会累积错误

	# 恢复 CardUI 回手牌容器
	var cardui_global := cardui.global_position
	_ui_layer.remove_child(cardui)
	_hand_card.add_child(cardui)
	cardui.global_position = cardui_global

	_dragging = false

	# 恢复 CardUI 的容器布局
	cardui.scale = Vector2(1, 1)
	cardui.top_level = _cardui_was_top_level

## 结束拖拽：只清理拖拽状态，不销毁（由 CardUI 子类决定后续行为）
func _end_drag() -> void:
	_dragging = false

## 从场景树移除并释放（CardUI 销毁时调用，避免孤儿节点泄漏）
func cleanup() -> void:
	if is_inside_tree():
		get_parent().remove_child(self)
	# 如果拖拽被中途取消但 cleanup 被调用，恢复 CardUI 的容器布局
	if _dragging:
		cardui.scale = Vector2(1, 1)
		# 卡牌结束时已通过 dissolve 动画释放，不需要移回手牌
		cardui.top_level = _cardui_was_top_level
		_dragging = false
	queue_free()

func _is_mouse_inside_card() -> bool:
	var rect := cardui.get_global_rect()
	var card_rect := Rect2(
		rect.position.x + rect.size.x * 0.5 - 29,
		rect.position.y + rect.size.y - 90,
		58,
		90
	)
	return card_rect.has_point(get_global_mouse_position())
