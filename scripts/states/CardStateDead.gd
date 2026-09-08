class_name CardStateDead extends CardState

func enter(machine: CardStateMachine) -> void:
	machine.disable_card()
