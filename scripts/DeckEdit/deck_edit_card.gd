## 卡组编辑面板中的可拖拽卡牌 UI（自建节点，无需 .tscn）
class_name DeckEditCard extends Control

const MINI_CARD_SIZE : Vector2 = Vector2(80 , 100)

signal dropped_on_slot(slot: DeckSlot)
signal removed_from_slot()

var card_key: DataManager.USINGCARD
var card_res: CardResource
var home_row: Node          ## 所属分类行
var in_slot: DeckSlot = null

var _dragging: bool = false
var _drag_offset: Vector2
var _panel: Control = null
var _slots: Array[Node] = []  ## 所有槽位引用，用于碰撞检测

var _texture_rect: TextureRect
var _mana_label: Label

func setup(key: DataManager.USINGCARD, res: CardResource, panel: Control, home: Node, slots: Array[Node]) -> void:
	card_key = key
	card_res = res
	_panel = panel
	home_row = home
	_slots = slots
	custom_minimum_size = MINI_CARD_SIZE
	_build_visuals()
	_apply_type_color()

func _build_visuals() -> void:
	# 卡片底色
	var front := ColorRect.new()
	front.name = "card_front"
	front.size = MINI_CARD_SIZE
	front.color = Color(0.15, 0.15, 0.15, 1)
	add_child(front)
	
	# 卡图
	_texture_rect = TextureRect.new()
	_texture_rect.name = "card_texture"
	_texture_rect.size = MINI_CARD_SIZE
	_texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	_texture_rect.texture = card_res.tetxure
	add_child(_texture_rect)

	# 边框
	var border := ColorRect.new()
	border.name = "border"
	border.size = MINI_CARD_SIZE
	border.color = Color.TRANSPARENT
	border.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(border)
	
	# 费用标签背景
	var mana_bg := ColorRect.new()
	mana_bg.name = "mana_bg"
	mana_bg.size = Vector2(24, 20)
	mana_bg.color = Color(0, 0, 0, 0.65)
	add_child(mana_bg)
	
	# 费用数字
	_mana_label = Label.new()
	_mana_label.name = "mana"
	_mana_label.position = Vector2(2, 0)
	_mana_label.size = Vector2(20, 20)
	_mana_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_mana_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_mana_label.add_theme_font_size_override("font_size", 14)
	_mana_label.text = str(card_res.mana)
	_mana_label.add_theme_color_override("font_color", Color.WHITE)
	add_child(_mana_label)
	
	# 名字（底部居中）
	var name_label := Label.new()
	name_label.name = "name"
	name_label.position = Vector2(0, 72)
	name_label.size = Vector2(58, 16)
	name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	name_label.add_theme_font_size_override("font_size", 10)
	name_label.add_theme_color_override("font_color", Color(1, 1, 1, 0.9))
	name_label.text = card_res.card_name
	add_child(name_label)


func _apply_type_color() -> void:
	var border := get_node_or_null("border") as ColorRect
	if not border:
		return
	match card_res.type:
		DataManager.PLAYERTYPE.MAGIC:
			border.color = Color(1, 0.45, 1, 0.5)
		DataManager.PLAYERTYPE.CONSTRUCTION:
			border.color = Color(0.3, 0.5, 1, 0.5)
		DataManager.PLAYERTYPE.WALKABLE:
			border.color = Color(0.95, 0.42, 0.3, 0.5)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and _is_mouse_inside():
			_start_drag()
		elif not event.pressed and _dragging:
			_end_drag()

func _process(_delta: float) -> void:
	if _dragging:
		global_position = get_global_mouse_position() - _drag_offset

func _is_mouse_inside() -> bool:
	return get_global_rect().has_point(get_global_mouse_position())

func _start_drag() -> void:
	if _dragging:
		return
	_dragging = true
	_drag_offset = get_global_mouse_position() - global_position

	# 如果当前在槽位中，通知槽位清空
	if in_slot:
		in_slot.remove_card()
		removed_from_slot.emit()
		in_slot = null
	
	# reparent 到面板根节点，保证拖拽时渲染在最上层
	var saved_global := global_position
	get_parent().remove_child(self)
	_panel.add_child(self)
	global_position = saved_global
	
	scale = Vector2(1.15, 1.15)

func _end_drag() -> void:
	_dragging = false
	scale = Vector2(1, 1)
	
	# 检查是否落在槽位上
	var target := _find_slot_under_mouse()
	if target and target.can_accept():
		_move_to_slot(target)
		dropped_on_slot.emit(target)
	else:
		_return_home()

func _move_to_slot(slot: DeckSlot) -> void:
	get_parent().remove_child(self)
	slot.add_child(self)
	position = Vector2.ZERO
	slot.set_card(self)
	in_slot = slot

func _return_home() -> void:
	get_parent().remove_child(self)
	home_row.add_child(self)
	position = Vector2.ZERO
	in_slot = null

func _find_slot_under_mouse() -> DeckSlot:
	for slot in _slots:
		if slot.get_global_rect().has_point(get_global_mouse_position()):
			return slot
	return null

## 从槽位移除回到分类行
func return_to_pool() -> void:
	if in_slot:
		in_slot.remove_card()
		in_slot = null
		removed_from_slot.emit()
	_return_home()
