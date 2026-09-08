class_name GameOver extends Control

@onready var again_button: Button = $ColorRect/AgainButton
@onready var game_over_label: Label = $GameOverLabel

func _ready() -> void:
	EventBus.base_damaged.connect(_on_base_damaged.bind())
	again_button.pressed.connect(_on_again_button_pressed)
	
func _on_base_damaged(base : Node2D) -> void:
	self.visible = true
	Engine.time_scale = 0.1
	if base is PlayerBase:
		game_over_label.text = "You Lose"
	elif base is EnemyBase:
		game_over_label.text = "You Win"
	
func _on_again_button_pressed() -> void:
	Engine.time_scale = 1.0
	get_tree().reload_current_scene()
