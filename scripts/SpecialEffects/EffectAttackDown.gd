class_name EffectAttackDown extends Node2D
## 降低本卡牌攻击力，持续 duration 毫秒

var duration: int = 3000
## 攻击修正系数（激活时 attack_multiplier 降为此值，默认 1.0 为满攻）
var multiplier: float = 0.5
var possibility : float = 0.3

var _activate_time: int = 0
var card: Card

func activate(applyer : Resource,context_card: Card) -> void:
	multiplier = applyer.multiplier
	duration = applyer.duration
	possibility = applyer.possibility
	
	if not is_instance_valid(context_card):
		return
	if randf() > possibility:
		return
	
	card = context_card
	card.attack_multiplier = multiplier
	_activate_time = Time.get_ticks_msec()
	visible = true
	set_physics_process(true)

func deactivate() -> void:
	if is_instance_valid(card):
		card.attack_multiplier = 1.0
	visible = false
	set_physics_process(false)

func _physics_process(_delta: float) -> void:
	if Time.get_ticks_msec() - _activate_time > duration:
		deactivate()

func ball_activate(ball_res : SpecialEffectBall,context_card : Card) -> void :
	multiplier = ball_res.multiplier
	possibility = ball_res.possibility
	duration = ball_res.duration
	
	if not is_instance_valid(context_card):
		return
	if randf() > possibility:
		return
	
	card = context_card
	card.attack_multiplier = multiplier
	_activate_time = Time.get_ticks_msec()
	visible = true
	set_physics_process(true)
