class_name CardUI extends Control

const CARD_SCENE := preload("res://scene/card.tscn")
const Squad := preload("res://scene/squad_player.tscn")

@export var card_res : CardResource

@onready var card_ui_texture: Sprite2D = $card_front/card_ui_texture
@onready var card_ui_area: Area2D = $card_front/CardUIArea
@onready var mana: Label = $card_front/CardManaLabel/mana

var target_area: Area2D
var _card_message: Control = null
var CarduiDragger : CardUIDragger
var _is_dissolving: bool = false
var _last_show_card_frame: int = -1

func _enter_tree() -> void:
	_on_mana_change(ManaManager.current_mana, ManaManager.max_mana)
	mouse_filter = Control.MOUSE_FILTER_PASS
	
	# 防止 reparent 时重复创建（如拖拽时 CardUI 从 hand_card 移到 ui_layer）
	if not CarduiDragger:
		CarduiDragger = CardUIDragger.new()
		CarduiDragger.SetUp(self)
		add_child(CarduiDragger)          # 修复：加入场景树
	
func _ready() -> void:
	card_ui_texture.texture = card_res.tetxure
	mana.text = str(card_res.mana)
	card_ui_area.area_entered.connect(_on_area_enter_card_ui.bind())
	card_ui_area.area_exited.connect(_on_area_exit_card_ui.bind())
	EventBus.mana_changed.connect(_on_mana_change)
	
	
func _input(event: InputEvent) -> void:
	if _is_dissolving or not is_instance_valid(CarduiDragger):
		return
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if CarduiDragger._is_mouse_inside_card():
				if not ManaManager.can_afford(card_res.mana):
					return  # 法力不够，不让拖
				CarduiDragger._start_drag()
		elif event.button_index == MOUSE_BUTTON_LEFT and not event.pressed and CarduiDragger.can_end_drag():
			if _is_over_discard_area():
				_discard()
			elif _is_placement_valid():
				_end_drag()
			else:
				CarduiDragger._cancel_drag()
			queue_redraw()  # 清除拖拽时画的范围圈
		elif event.button_index == MOUSE_BUTTON_LEFT and not event.pressed and CarduiDragger.is_dragging():
			# 按住时间太短 → 取消拖拽，回到手牌
			CarduiDragger._cancel_drag()
			queue_redraw()
		elif event.button_index == MOUSE_BUTTON_RIGHT and event.pressed and CarduiDragger.is_dragging():
			CarduiDragger._cancel_drag()
			queue_redraw()

func _physics_process(_delta: float) -> void:
	if _is_dissolving or not is_instance_valid(CarduiDragger):
		return
	if CarduiDragger.is_dragging():
		global_position = get_global_mouse_position() - CarduiDragger.get_drag_offset()
		queue_redraw()
		return  # 拖拽中不显示 cardmessage

	# cardmessage：同一帧内只更新一次，避免每帧反复调用导致闪动
	if CarduiDragger._is_mouse_inside_card():
		var frame := Engine.get_process_frames()
		if frame != _last_show_card_frame:
			_last_show_card_frame = frame
			var msg := _get_card_message()
			if msg:
				msg.show_card(card_res, get_global_mouse_position())

func _get_card_message() -> Control:
	if not _card_message:
		_card_message = get_tree().get_first_node_in_group("card_message")
	return _card_message

## 是否停在弃牌区上方
func _is_over_discard_area() -> bool:
	return target_area != null and target_area.is_in_group("discard")

## 弃牌：返还一半法力
func _discard() -> void:
	AduioManager.play(AduioManager.Sound.DISCORDCARD)
	CarduiDragger.cleanup()            # 修复：清理拖拽器
	ManaManager.recover_mana(float(card_res.mana) / 2.0)
	play_dissolve_and_free()

func _on_area_enter_card_ui(area: Area2D) -> void:
	target_area = area

func _on_area_exit_card_ui(area: Area2D) -> void:
	if target_area == area:
		target_area = null

## 子类重写：当前位置是否可以放置
func _is_placement_valid() -> bool:
	return false

## 执行放置（子类重写：扣法力、生成单位，最后调用 cleanup + dissolve）
func _end_drag() -> void:
	CarduiDragger.cleanup()
	play_dissolve_and_free()

func play_dissolve_and_free() -> void:
	if _is_dissolving:                # 防重入
		return
	_is_dissolving = true
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	var start_pos := position
	var start_scale := scale
	
	# 阶段一：蓄力爆闪（0.15s）—— 放大 + 强烈变亮 + 轻微抖动
	var charge := create_tween().set_parallel(true).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	charge.tween_property(self, "scale", start_scale * 1.35, 0.15)
	charge.tween_property(self, "modulate", Color(2.2, 2.2, 2.2, 1.0), 0.15)
	# 抖动：左右快速摆动
	charge.tween_property(self, "rotation", 0.12, 0.05)
	charge.tween_property(self, "rotation", -0.12, 0.05)
	charge.tween_property(self, "rotation", 0.0, 0.05)

	# 阶段二：上抛爆开消散（0.45s）—— 大幅上抛 + 高速旋转 + 先爆开再缩小 + 淡出
	var fly := create_tween().set_parallel(true).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	fly.tween_property(self, "position", start_pos + Vector2(0, -90), 0.45)
	fly.tween_property(self, "rotation", -1.2, 0.45)
	# 先爆开放大到 1.6 倍，再缩小到 0
	fly.tween_property(self, "scale", start_scale * 1.6, 0.18)
	fly.tween_property(self, "scale", Vector2.ZERO, 0.27)
	fly.tween_property(self, "modulate:a", 0.0, 0.45)
	
	AduioManager.play(AduioManager.Sound.USECARD)
	
	# 串联：蓄力完成后接消散，最后销毁
	charge.chain().tween_callback(func():
		fly.play()
	)
	fly.chain().tween_callback(queue_free)

## 拖拽时绘制攻击范围指示圈（圆心在卡牌底部中央 = 单位生成位置）
func _draw() -> void:
	if not CarduiDragger or not CarduiDragger.is_dragging():
		return
	var center := Vector2(size.x / 2.0, size.y / 2.0)
	var radius := card_res.attack_range * 2
	# 半透明填充
	draw_circle(center, radius, Color(1.0, 0.35, 0.35, 0.15))
	# 实线边框
	draw_arc(center, radius, 0, TAU, 64, Color(1.0, 0.35, 0.35, 0.7), 2.0)

func _on_mana_change(current: float, _max: float) -> void:
	if _is_dissolving:                # 动画中不覆盖 modulate
		return
	if current < card_res.mana:
		self.modulate = Color(0.3,0.3,0.3)
	else:
		self.modulate = Color(1,1,1)
