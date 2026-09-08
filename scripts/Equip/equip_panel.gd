## 卡牌装备面板 — 给出战卡牌装备特殊效果球
class_name EquipPanel extends Control

@onready var ball_list: VBoxContainer = %BallList
@onready var card_list: VBoxContainer = %CardList
@onready var ball_inv_hint: Label = %BallInvHint

const ballui_tscn := preload("res://scene/ball_ui.tscn")

var ballui : BallUi  
var _card_rows: Array[CardEquipRows] = []
var _card_factory: CardFactory

func _ready() -> void:
	_card_factory = CardFactory.new()
	_refresh_cards()
	EventBus.ball_collected.connect(_on_ball_collected.bind())
	EventBus.ball_equipped_to_card.connect(_on_ball_eqiuped_to_card.bind())

## 左侧 — 球库存（每个 BallUi 自带 BallUiDragger 管理拖拽）
func _on_ball_collected(ball_res : SpecialEffectBall) -> void:
	ballui = ballui_tscn.instantiate()
	ballui.SetUp(ball_res, self, _card_rows, ball_list)
	ball_list.add_child(ballui)
	ball_inv_hint.visible = ball_list.get_children().is_empty()

## 右侧 — 出战卡牌
func _refresh_cards() -> void:
	var deck := GameManager.get_deck()
	for key in deck:
		var res: CardResource = _card_factory.create_card(key)
		var row := CardEquipRows.new()
		row.setup(key, res)
		card_list.add_child(row)
		_card_rows.append(row)

func _on_ball_eqiuped_to_card(_ball_res: SpecialEffectBall, _target_key: DataManager.USINGCARD) -> void:
	AduioManager.play(AduioManager.Sound.EQUIP)
	ball_inv_hint.visible = ball_list.get_children().is_empty()
