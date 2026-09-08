class_name SpecialEffectBall extends Resource

@export var ball_name: String
@export var effect: DataManager.SPECIALEFFECTS
@export var target_attribute: DataManager.ATTRIBUTE = DataManager.ATTRIBUTE.NO
@export var texture : Texture2D
@export var modulate : Color
@export var discription : String

@export var duration : int
@export var multiplier : float
@export var possibility : float


## 对目标应用此球效果（必须属性匹配，
func try_apply_to(target: Card) -> void:
	if not is_instance_valid(target):
		return
	if target.card_resource.attribute != target_attribute:
		return
	target.special_effects.ball_apply(self, target)
