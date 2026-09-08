extends CanvasLayer

const CARD_UI_SOLDIER = preload("uid://blfuaxc6q8q0t")
const CARD_UI_BUILDING = preload("uid://5nf37rdy2riw")
const CARD_UI_MAGIC = preload("uid://cktnbmope65d3")
const DRAW_CARD_COST : int = 10
const MAX_HAND_SIZE : int = 7

@onready var drawcardmanalabel: Label = %drawcardmanalabel
@onready var handcard: HBoxContainer = %handcard
@onready var draw_card_button: TextureButton = %DrawCardButton
@onready var equip_panel: Control = $EquipPanel
@onready var discordcard_area: Area2D = %discordcardArea

var card_factory : CardFactory = CardFactory.new()

func _ready() -> void:
	EventBus.mana_changed.connect(_on_mana_changed)
	_on_mana_changed(ManaManager.get_mana(), ManaManager.max_mana)

	# 从 GameManager 读取卡组并给初始手牌
	_setup_deck()

	drawcardmanalabel.text = str(DRAW_CARD_COST)
	discordcard_area.add_to_group("discard")


## 从 GameManager 加载卡组（DeckEditPanel 确认时存入的）
func _setup_deck() -> void:
	var saved: Array = GameManager.get_deck()
	for key in saved:
		card_factory.add_to_deck(key)
	# 初始手牌：从卡组抽两张
	draw_card(card_factory.draw_random_from_deck())
	draw_card(card_factory.draw_random_from_deck())

func draw_card(card : DataManager.USINGCARD) -> void:
	if handcard.get_child_count() >= MAX_HAND_SIZE:
		return
	
	var new_card_res : CardResource = card_factory.create_card(card)
	
	var cardUi : CardUI
	match new_card_res.type:
		DataManager.PLAYERTYPE.WALKABLE:
			cardUi = CARD_UI_SOLDIER.instantiate()
		DataManager.PLAYERTYPE.CONSTRUCTION:
			cardUi = CARD_UI_BUILDING.instantiate()
		DataManager.PLAYERTYPE.MAGIC:
			cardUi = CARD_UI_MAGIC.instantiate()
		_:
			cardUi = CARD_UI_BUILDING.instantiate()
	cardUi.card_res = new_card_res
	handcard.add_child(cardUi)

func _on_draw_card_button_pressed() -> void:
	if handcard.get_child_count() >= MAX_HAND_SIZE:
		return
	if not ManaManager.spend_mana(DRAW_CARD_COST):
		return
		
	AduioManager.play(AduioManager.Sound.DRAWCARD)
	draw_card(card_factory.draw_random_from_deck())

func _on_mana_changed(current: int, max_: int) -> void:
	%ManaLabel.text = "%d / %d" % [current, max_]
	draw_card_button.disabled = !ManaManager.can_afford(DRAW_CARD_COST) or handcard.get_child_count() >= MAX_HAND_SIZE

func _on_equip_button_pressed() -> void:
	equip_panel.visible = not equip_panel.visible
	Engine.time_scale = !equip_panel.visible
