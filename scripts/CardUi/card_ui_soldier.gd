## 士兵卡：拖到战场地面，生成沿路径前进的单位
class_name CardUISoldier extends CardUI

func _is_placement_valid() -> bool:
	return true

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
	
	var map: Map = get_tree().current_scene
	map.soldier_spawn.add_child(new_card)
	new_card.position = Vector2.ZERO
	
	CarduiDragger.cleanup()
	play_dissolve_and_free()
