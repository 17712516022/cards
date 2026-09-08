class_name CardStateIdle extends CardState

func update(machine: CardStateMachine) -> void:
	if machine.card.card_resource is CardResource and machine.card.card_resource.type == DataManager.PLAYERTYPE.CONSTRUCTION:
		pass
	else :
		machine.card_animation_player.play("idle")
	
	# 魔法卡直接攻击（不需要进入范围）；EnemyCardResource 没有 type 属性，先判类型
	if machine.card.card_resource is CardResource and machine.card.card_resource.type == DataManager.PLAYERTYPE.MAGIC:
		machine.transition_to(machine._state_attacking)
	elif machine.has_enemies() and machine.can_attack():
		machine.transition_to(machine._state_attacking)
