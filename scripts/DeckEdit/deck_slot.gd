## 卡组编辑面板中的卡槽
class_name DeckSlot extends Control

var current_card: DeckEditCard = null
var slot_index: int = -1

func _draw() -> void:
	var rect := Rect2(Vector2.ZERO, size - Vector2(1, 1))
	if current_card:
		draw_rect(Rect2(Vector2.ZERO, size), Color(0.8, 0.8, 0.2, 0.15), true)
	else:
		draw_rect(rect, Color(0.5, 0.5, 0.5, 0.08), true)
		draw_rect(rect, Color(0.5, 0.5, 0.5, 0.3), false, 2)
	
	# 槽位编号
	if not current_card:
		draw_string(ThemeDB.fallback_font,
			Vector2(size.x / 2 - 5, 20),
			str(slot_index + 1),
			HORIZONTAL_ALIGNMENT_CENTER, -1, 14,
			Color(0.5, 0.5, 0.5, 0.3))

func can_accept() -> bool:
	return current_card == null

func set_card(card: DeckEditCard) -> void:
	current_card = card
	queue_redraw()

func remove_card() -> void:
	current_card = null
	queue_redraw()
