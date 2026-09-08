class_name EffectComponent extends Node2D
## 效果组件管理器 —— Card 固有子节点，管理 debuff 效果

@onready var slow_down: EffectSlowDown = %SlowDown
@onready var attack_down: EffectAttackDown = %AttackDown
@onready var pause: EffectPauseEnemy = %Pause
@onready var block_down: EffectBlockDown = %BlockDown
@onready var metal_killer: MetalKiller = %MetalKiller
@onready var demon_killer: DemonKiller = %DemonKiller
@onready var angel_killer: AngelKiller = %AngelKiller
@onready var zombin_killer: ZombinKiller = %ZombinKiller
@onready var noattribute_killer: NoAttributeKiller = %NoAttributeKiller

var card: Card
var effects_dic: Dictionary

func _ready() -> void:
	effects_dic = {
		DataManager.SPECIALEFFECTS.ATTACKDOWN: attack_down,
		DataManager.SPECIALEFFECTS.SLOWDOWN: slow_down,
		DataManager.SPECIALEFFECTS.PAUSEENEMY: pause,
		DataManager.SPECIALEFFECTS.BLOCKDOWN : block_down,
		DataManager.SPECIALEFFECTS.METALKILLER : metal_killer,
		DataManager.SPECIALEFFECTS.DEMONKILLER : demon_killer,
		DataManager.SPECIALEFFECTS.ANGELKILLER : angel_killer,
		DataManager.SPECIALEFFECTS.ZOMBINKILLER : zombin_killer,
		DataManager.SPECIALEFFECTS.NOATTRIBUTEKILLER : noattribute_killer,
	}

func SetUp(context_card: Card) -> void:
	card = context_card

## 对本卡牌施加效果
func apply(applyer : Resource,effects: Array) -> void:
	for effect in effects:
		effects_dic[effect].activate(applyer,card)

## 应用装备球效果到指定卡牌（仅激活该球对应的效果，而非全部）
func ball_apply(ball_res : SpecialEffectBall, context_card: Card) -> void:
	effects_dic[ball_res.effect].ball_activate(ball_res, context_card)
