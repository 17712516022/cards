class_name EnemyCardResource extends Resource

@export var card_name : String = ""
@export var attack : float
@export var health : float
@export var speed : float
@export var attack_range : float
@export var attack_coolingdown : float
## 最大攻击目标数，0 表示不限（群体攻击）
@export var max_targets : int = 0
@export var tetxure : Texture2D
@export var modulate : Color

@export var special_effects : Array[DataManager.SPECIALEFFECTS]
@export var attribute : DataManager.ATTRIBUTE

@export var duration : int
@export var multiplier : float
@export var possibility : float
