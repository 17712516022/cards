class_name SquadEnemy extends Node2D

var enemy : Card

func SetUp(context_enemy : Card) -> void:
	enemy = context_enemy

func _ready() -> void:
	get_child(0).SetUp(enemy)
