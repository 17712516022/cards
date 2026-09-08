class_name DeckEditPanel extends Control

@onready var card_pool: VBoxContainer = %CardPool
@onready var confirm_btn: Button = %ConfirmBtn
@onready var slot_container: HBoxContainer = %SlotContainer

var card_factory: CardFactory
var slots: Array[Node] = []
var all_cards: Array[DeckEditCard] = []

# ── 类别标签映射 ──
const CAT_NAMES := {
	"WALKABLE":     "士兵",
	"CONSTRUCTION": "建筑",
	"MAGIC":        "魔法",
}


func _ready() -> void:
	AduioManager.play(AduioManager.Sound.PICKCARD)
	confirm_btn.pressed.connect(_on_confirm)
	card_factory = CardFactory.new()
	slots = slot_container.get_children()
	
	_build_card_pool()
	
## 按类别排列卡牌
func _build_card_pool() -> void:
	var categorized: Dictionary = {}
	for key in card_factory.cards:
		var res: CardResource = card_factory.cards[key]
		var cat: String = _cat_key(res.type)
		if cat.is_empty():
			continue
		if not categorized.has(cat):
			categorized[cat] = []
		categorized[cat].append({ "key": key, "res": res })
	
	for cat in ["WALKABLE", "CONSTRUCTION", "MAGIC"]:
		if not categorized.has(cat):
			continue
		
		# 类别标签
		var label := Label.new()
		label.text = CAT_NAMES.get(cat, cat)
		label.add_theme_font_size_override("font_size", 16)
		label.add_theme_color_override("font_color", Color(1, 1, 1, 0.75))
		card_pool.add_child(label)
		
		# 卡牌行
		var row := HBoxContainer.new()
		row.custom_minimum_size = Vector2(0,80)
		row.add_theme_constant_override("separation", 8)
		card_pool.add_child(row)
	
		for data in categorized[cat]:
			var card := DeckEditCard.new()
			
			card.setup(data["key"], data["res"], self, row, slots)
			row.add_child(card)
			all_cards.append(card)

func _cat_key(t: DataManager.PLAYERTYPE) -> String:
	match t:
		DataManager.PLAYERTYPE.WALKABLE:     return "WALKABLE"
		DataManager.PLAYERTYPE.CONSTRUCTION: return "CONSTRUCTION"
		DataManager.PLAYERTYPE.MAGIC:        return "MAGIC"
	return ""

## 确认 → 保存卡组 → 进入地图
func _on_confirm() -> void:
	var deck: Array = []
	for slot in slots:
		if slot.current_card:
			deck.append(slot.current_card.card_key)
	if deck.size() == 0:
		return
	
	GameManager.save_deck(deck)
	get_tree().change_scene_to_file("res://scene/map.tscn")
