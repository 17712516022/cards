class_name Slots extends Area2D

@onready var slots_animationer: AnimationPlayer = %slotsAnimationer

func _ready() -> void:
	self.area_entered.connect(_on_area_enter.bind())
	self.area_exited.connect(_on_area_exit.bind())

func has_card() -> bool:
	for child in get_children():
		if child is Card:
			return true
	return false

func _on_area_enter(area: Area2D) -> void:
	if not has_card():
		slots_animationer.play("blink")

func _on_area_exit(area: Area2D) -> void:
	slots_animationer.stop()
