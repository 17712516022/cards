class_name CardStateAttacking extends CardState

const ANIM_TIMEOUT := 3.0  # 动画最大等待秒数

func enter(machine: CardStateMachine) -> void:
	machine.TargetCalculater.clean_enemies()
	
	if machine.card_animation_player and machine.card_animation_player.has_animation("attack"):
		machine.card_animation_player.play("attack")
		# 超时保护：防止动画中断导致永久卡死
		var elapsed := 0.0
		while machine.card_animation_player.is_playing() and elapsed < ANIM_TIMEOUT:
			await machine.get_tree().process_frame
			elapsed += machine.get_process_delta_time()
		machine.card_animation_player.stop()
	
	machine.do_attack()
	if machine.card.card_resource is CardResource and machine.card.card_resource.type == DataManager.PLAYERTYPE.MAGIC:
		machine.transition_to(machine._state_dead)
	else:
		machine.transition_to(machine._state_idle)
