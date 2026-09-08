class_name EffectBlockDown extends Node2D

var duration: int = 3000
## defend修正系数
var multiplier: float = 2
var possibility : float = 0.3

var _activate_time: int = 0
var card: Card

func activate(applyer : Resource,context_card: Card) -> void:
	multiplier = applyer.multiplier + 1
	duration = applyer.duration
	possibility = applyer.possibility
	
	if not is_instance_valid(context_card):
		return
	if randf() > possibility:
		return
	
	card = context_card
	card.hurt_multiplier = multiplier
	_activate_time = Time.get_ticks_msec()
	visible = true
	set_physics_process(true)

func deactivate() -> void:
	if is_instance_valid(card):
		card.hurt_multiplier = 1.0
	visible = false
	set_physics_process(false)

func _physics_process(_delta: float) -> void:
	if Time.get_ticks_msec() - _activate_time > duration:
		deactivate()

func ball_activate(ball_res : SpecialEffectBall,context_card : Card) -> void :
	multiplier = ball_res.multiplier
	duration = ball_res.duration
	possibility = ball_res.possibility
	
	if not is_instance_valid(context_card):
		return
	if randf() > possibility:
		return
	
	card = context_card
	card.hurt_multiplier = multiplier
	_activate_time = Time.get_ticks_msec()
	visible = true
	set_physics_process(true)
