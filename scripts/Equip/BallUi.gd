class_name BallUi extends Control

@onready var ballui_texture: TextureRect = %balluiTexture
@onready var ball_discription: Label = %BallDescription

## 当前显示的特殊效果球资源
var ball_res: SpecialEffectBall

var BalluiDragger: BallUiDragger
var _card_rows: Array[CardEquipRows] = []
var _main_panel: Control
var _ball_list: VBoxContainer
## 装备时记录目标卡牌的键，用于 emit 信号时过滤接收方
var _target_card_key: DataManager.USINGCARD

func SetUp(ball: SpecialEffectBall, panel: Control, card_rows: Array[CardEquipRows], ball_list_ref: VBoxContainer) -> void:
	ball_res = ball
	_main_panel = panel
	_card_rows = card_rows
	_ball_list = ball_list_ref
	# 固定最小高度，保持列表行高一致
	custom_minimum_size = Vector2(0, 52)
	
	# 在 SetUp 中初始化 BallUiDragger（此时 _main_panel 和 _ball_list 都已就绪）
	if not BalluiDragger:
		BalluiDragger = BallUiDragger.new()
		BalluiDragger.SetUp(self, _ball_list, _main_panel.get_parent())
		add_child(BalluiDragger)

func _ready() -> void:
	InitBallUi()

## 用球资源数据填充 UI：纹理和描述文字
func InitBallUi() -> void:
	if ball_res.texture != null:
		ballui_texture.texture = ball_res.texture
		ballui_texture.modulate = ball_res.modulate
	
	if ball_res.possibility > 0.01:
		ball_discription.text = ball_res.ball_name + " : " + str(ball_res.possibility * 100) + "%概率" +ball_res.discription + str(ball_res.duration / 1000) + "秒" if ball_res.discription else ""
	else :
		ball_discription.text = ball_res.ball_name + " : " + ball_res.discription if ball_res.discription else ""
	
	ballui_texture.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ball_discription.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _enter_tree() -> void:
	mouse_filter = Control.MOUSE_FILTER_PASS

func _input(event: InputEvent) -> void:
	if not is_instance_valid(BalluiDragger):
		return
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if BalluiDragger._is_mouse_inside_ball():
				BalluiDragger._start_drag()
		elif event.button_index == MOUSE_BUTTON_LEFT and not event.pressed and BalluiDragger.is_dragging():
			if _try_equip():
				_end_drag()
			else:
				BalluiDragger._cancel_drag()
		elif event.button_index == MOUSE_BUTTON_RIGHT and event.pressed and BalluiDragger.is_dragging():
			BalluiDragger._cancel_drag()

## 拖拽中每帧跟随鼠标
func _physics_process(_delta: float) -> void:
	if not is_instance_valid(BalluiDragger):
		return
	if BalluiDragger.is_dragging():
		global_position = get_global_mouse_position() - BalluiDragger.get_drag_offset()
		return

## 检测释放位置是否命中有效行，命中则执行装备并返回 true
func _try_equip() -> bool:
	var target_row := _find_row_under_mouse()
	if not target_row or not target_row.can_accept_ball():
		return false
	var card: CardResource = target_row.get_card_resource()
	if not card or card.equipped_balls.has(ball_res):
		return false
	card.equipped_balls.append(ball_res)
	GameManager.remove_ball(ball_res)
	_target_card_key = target_row.card_key
	return true

## 遍历所有卡片行，返回鼠标当前落在哪个行节点上
func _find_row_under_mouse() -> CardEquipRows:
	var mouse_pos := get_global_mouse_position()
	for row in _card_rows:
		if not is_instance_valid(row):
			continue
		if row.get_global_rect().has_point(mouse_pos):
			return row
	return null

## 执行放置：清理拖拽器并销毁自身
func _end_drag() -> void:
	BalluiDragger.cleanup()
	EventBus.ball_equipped_to_card.emit(ball_res, _target_card_key)
	queue_free()
