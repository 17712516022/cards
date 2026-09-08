class_name EffectSlowDown extends Node2D
## 降低本卡牌移动速度，持续 duration 秒

var multiplier: float = 0.2
var duration: int = 3000
var possibility : float = 0.3
var Time_since_slow : int = Time.get_ticks_msec()

var card : Card

func activate(applyer : Resource,context_card: Card) -> void:
	multiplier = applyer.multiplier
	duration = applyer.duration
	possibility = applyer.possibility
	
	if not is_instance_valid(context_card):
		return
	if randf() > possibility:
		return
	
	card = context_card
	Time_since_slow = Time.get_ticks_msec()
	card.speed_multiplier = multiplier
	visible = true
	set_physics_process(true)

func deactivate() -> void:
	if is_instance_valid(card):
		card.speed_multiplier = 1.0
	visible = false
	set_physics_process(false)

func _physics_process(_delta: float) -> void:
	if Time.get_ticks_msec() - Time_since_slow > duration:
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
	Time_since_slow = Time.get_ticks_msec()
	card.speed_multiplier = multiplier
	visible = true
	set_physics_process(true)
