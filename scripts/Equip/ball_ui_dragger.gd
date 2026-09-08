class_name BallUiDragger extends Node2D

var _dragging: bool = false
var _local_offset: Vector2

var ballui : BallUi
var ball_list : VBoxContainer
var canvaslayer : CanvasLayer

func SetUp(context_ballui : BallUi,context_ball_list : VBoxContainer, context_canvaslayer : CanvasLayer) -> void:
	ballui = context_ballui
	ball_list = context_ball_list
	canvaslayer = context_canvaslayer

func is_dragging() -> bool:
	return _dragging

func get_drag_offset() -> Vector2:
	return _local_offset

func _start_drag() -> void:
	if _dragging:
		return
	_local_offset = get_global_mouse_position() - global_position
	_dragging = true
	
	# 1. CardUIDragger 移到 UI 层，避免被 CardUI 的 dissolve 一起销毁
	var saved_global := global_position
	ballui.remove_child(self)
	canvaslayer.add_child(self)
	global_position = saved_global
	position = get_global_mouse_position() - _local_offset

	# 2. CardUI 移到 UI 层，脱离手牌容器的排序/裁剪影响
	var ballui_global := ballui.global_position
	ball_list.remove_child(ballui)
	canvaslayer.add_child(ballui)
	ballui.global_position = ballui_global


func _cancel_drag() -> void:
	# 恢复 BallUiDragger 到 ballui 子节点
	get_parent().remove_child(self)
	ballui.add_child(self)
	position = Vector2.ZERO                 # 归零！否则下次 _start_drag 的 _local_offset 会累积错误
	
	# 恢复 CardUI 回手牌容器
	var ballui_global := ballui.global_position
	canvaslayer.remove_child(ballui)
	ball_list.add_child(ballui)
	ballui.global_position = ballui_global
	
	_dragging = false
	

## 结束拖拽：只清理拖拽状态，不销毁（由 ballui子类决定后续行为）
func _end_drag() -> void:
	_dragging = false

## 从场景树移除并释放（ballui 销毁时调用，避免孤儿节点泄漏）
func cleanup() -> void:
	if is_inside_tree():
		get_parent().remove_child(self)
	# 如果拖拽被中途取消但 cleanup 被调用，恢复 CardUI 的容器布局
	if _dragging:
		_dragging = false
	queue_free()

func _is_mouse_inside_ball() -> bool:
	return ballui.get_global_rect().has_point(get_global_mouse_position())
