class_name EffectPauseEnemy extends Node2D
## 冻结本卡牌，持续 duration 毫秒

var duration: int = 2000
var possibility : float = 0.3

var _activate_time: int = 0
var card : Card

func activate(applyer : Resource ,context_card: Card) -> void:
	duration = applyer.duration
	possibility = applyer.possibility
	
	if not is_instance_valid(context_card):
		return
	if randf() > possibility:
		return
	
	card = context_card
	card.speed_multiplier = 0.0
	card.set_physics_process(false)
	_activate_time = Time.get_ticks_msec()
	visible = true
	set_physics_process(true)

func deactivate() -> void:
	if is_instance_valid(card):
		card.speed_multiplier = 1.0
		card.set_physics_process(true)
	visible = false
	set_physics_process(false)

func _physics_process(_delta: float) -> void:
	if Time.get_ticks_msec() - _activate_time > duration:
		deactivate()

func ball_activate(ball_res : SpecialEffectBall,context_card : Card) -> void :
	duration = ball_res.duration
	possibility = ball_res.possibility
	
	if not is_instance_valid(context_card):
		return
	if randf() > possibility:
		return
	
	card = context_card
	card.speed_multiplier = 0.0
	card.set_physics_process(false)
	_activate_time = Time.get_ticks_msec()
	visible = true
	set_physics_process(true)
