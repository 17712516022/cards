class_name EnemyBase extends Node2D

const MAX_ENEMY_BASE_HEALTH : int = 50

@onready var enemy_base_label: Label = %EnemyBaseLabel
@onready var enemybasearea: Area2D = %enemybasearea
@onready var enemy_base_animation_player: AnimationPlayer = %EnemyBaseAnimationPlayer

var enemy_base_health : int

func _ready() -> void:
	enemy_base_health = MAX_ENEMY_BASE_HEALTH
	_set_enemy_base_label()
	EventBus.enemy_base_hurted.connect(_on_enemy_base_hurted)
	enemybasearea.body_entered.connect(_on_body_entered)
	
func _set_enemy_base_label() -> void:
	enemy_base_label.text = str(enemy_base_health) 

func _on_body_entered(body : Node2D) -> void:
	if body.has_node("SquadPlayer"):
		enemy_base_animation_player.play("hurt")
		EventBus.enemy_base_hurted.emit()

func _on_enemy_base_hurted() -> void:
	AduioManager.play(AduioManager.Sound.BASEHURT)
	enemy_base_health = max(0,enemy_base_health - 1)
	if enemy_base_health <= 0:
		EventBus.base_damaged.emit(self)
	_set_enemy_base_label()
