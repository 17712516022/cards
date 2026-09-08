## 建筑卡：拖到空槽位，生成不动单位
class_name CardUIBuilding extends CardUI

func _is_placement_valid() -> bool:
	return target_area is Slots and not target_area.has_card()

func _end_drag() -> void:
	if not ManaManager.spend_mana(card_res.mana):
		CarduiDragger._cancel_drag()
		return
	
	var new_card: Card = CARD_SCENE.instantiate()
	var dup := card_res.duplicate()
	dup.equipped_balls = card_res.equipped_balls.duplicate()
	new_card.card_resource = dup

	var squad: Node2D = Squad.instantiate()
	new_card.add_child(squad)

	target_area.add_child(new_card)
	new_card.position = Vector2.ZERO

	CarduiDragger.cleanup()
	play_dissolve_and_free()
