class_name PlayerBase extends Node2D

const MAX_BASE_HEALTH : int = 50

@onready var basearea: Area2D = %basearea
@onready var player_base_label: Label = %PlayerBaseLabel
@onready var player_base_animation_player: AnimationPlayer = %PlayerBaseAnimationPlayer

var base_health : int

func _ready() -> void:
	base_health = MAX_BASE_HEALTH
	_set_base_label()
	EventBus.player_base_hurted.connect(_on_base_hurted)
	basearea.body_entered.connect(_on_body_entered)
	
func _set_base_label() -> void:
	player_base_label.text = str(base_health) 

func _on_body_entered(body : Node2D) -> void:
	if body.has_node("SquadEnemy"):
		player_base_animation_player.play("hurt")
		EventBus.player_base_hurted.emit()

func _on_base_hurted() -> void:
	AduioManager.play(AduioManager.Sound.BASEHURT)
	base_health = max(0,base_health - 1)
	if base_health <= 0:
		EventBus.base_damaged.emit(self)
	_set_base_label()
