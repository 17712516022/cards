class_name CardResource extends Resource

@export var card_name : String = ""
@export var type : DataManager.PLAYERTYPE
@export var mana : int
@export var attack : float
@export var health : float
@export var speed : float
@export var attack_range : float
@export var attack_coolingdown : float
## 最大攻击目标数，0 表示不限（群体攻击）
@export var max_targets : int = 0
@export var tetxure : Texture2D

@export var target_attribute : Array[DataManager.ATTRIBUTE]
@export var special_effects : Array[DataManager.SPECIALEFFECTS]
var equipped_balls : Array[SpecialEffectBall] = []

@export var duration : int
@export var multiplier : float
@export var possibility : float
