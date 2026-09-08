class_name Ball extends Node2D

@export var ball_resource: SpecialEffectBall
@onready var ball_sprite_2d: Sprite2D = %BallSprite2D
@onready var ball_area: Area2D = %BallArea

var _collected: bool = false
var _float_time: float = 0.0

func _ready() -> void:
	InitBall()
	ball_area.mouse_entered.connect(_on_mouse_entered)

func InitBall() -> void:
	if ball_resource and ball_resource.texture:
		ball_sprite_2d.texture = ball_resource.texture
		modulate = ball_resource.modulate

func _on_mouse_entered() -> void:
	_collect()

func _process(delta: float) -> void:
	# 上下浮动动画
	_float_time += delta
	ball_sprite_2d.position.y = sin(_float_time * 3.0) * 4.0

func _collect() -> void:
	if _collected:
		return
	_collected = true
	
	# 存入背包
	GameManager.collect_ball(ball_resource)
	
	# 广播信号（可播放收集特效）
	EventBus.ball_collected.emit(ball_resource)
	
	# 自身销毁
	queue_free()
