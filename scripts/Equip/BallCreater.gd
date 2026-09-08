class_name BallCreater extends Node

const BASIC_POSSIBILITY: float = 0.15
const BALL_SCENE := preload("res://scene/Ball.tscn")

const 僵尸杀手球 = preload("uid://cpos3i0l2ft3c")
const 钢铁杀手球 = preload("uid://crxjayrd0vucw")
const 无属性杀手 = preload("uid://crvol3p0pjdbi")
const 恶魔杀手 = preload("uid://c5je0db8xfohs")
const 对僵尸时停 = preload("uid://dl7rfx4gx72ga")
const 对天使时停 = preload("uid://koto51a7fpi8")
const 对恶魔时停 = preload("uid://chno8f3ou4rv1")
const 对无属性时停 = preload("uid://brsjbv222ylmy")
const 对钢铁时停 = preload("uid://bx24yfy7f724")
const 天使杀手 = preload("uid://c617enpvekxkf")
const 对僵尸减速 = preload("uid://camqw6a03dmw8")
const 对僵尸破防 = preload("uid://cwa5tnqp3n4ko")
const 对僵尸降攻 = preload("uid://u8dkxdepg0wb")
const 对天使减速 = preload("uid://j54frhpnw12k")
const 对天使破防 = preload("uid://dvg80dvuq5a1a")
const 对天使降攻 = preload("uid://dkvn2surw1103")
const 对恶魔减速 = preload("uid://cjblbe4wuoa3a")
const 对恶魔破防 = preload("uid://cy4tkwsvpjja3")
const 对恶魔降攻 = preload("uid://bgv88jbr2dvmm")
const 对无属性减速 = preload("uid://3dn2c3mfk3fp")
const 对无属性破防 = preload("uid://cj3xht1gideh5")
const 对无属性降攻 = preload("uid://bvt6vcnf0jlc7")
const 对钢铁减速 = preload("uid://bd70x3el2uje")
const 对钢铁破防 = preload("uid://cgdbs472yg1op")
const 对钢铁降攻 = preload("uid://bw0xqw06u8y5v")

var balls : Dictionary = {
	DataManager.BALL_CONFIGS.僵尸杀手球 : 僵尸杀手球,
	DataManager.BALL_CONFIGS.钢铁杀手球 : 钢铁杀手球,
	DataManager.BALL_CONFIGS.无属性杀手 : 无属性杀手,
	DataManager.BALL_CONFIGS.恶魔杀手 : 恶魔杀手,
	DataManager.BALL_CONFIGS.天使杀手 : 天使杀手,
	
	DataManager.BALL_CONFIGS.对恶魔时停 : 对恶魔时停,
	DataManager.BALL_CONFIGS.对僵尸时停 : 对僵尸时停,
	DataManager.BALL_CONFIGS.对天使时停 : 对天使时停,
	DataManager.BALL_CONFIGS.对钢铁时停 : 对钢铁时停,
	DataManager.BALL_CONFIGS.对无属性时停 : 对无属性时停,
	
	DataManager.BALL_CONFIGS.对恶魔减速 : 对恶魔减速,
	DataManager.BALL_CONFIGS.对僵尸减速 : 对僵尸减速,
	DataManager.BALL_CONFIGS.对天使减速 : 对天使减速,
	DataManager.BALL_CONFIGS.对钢铁减速 : 对钢铁减速,
	DataManager.BALL_CONFIGS.对无属性减速 : 对无属性减速,
	
	DataManager.BALL_CONFIGS.对恶魔破防 : 对恶魔破防,
	DataManager.BALL_CONFIGS.对僵尸破防 : 对僵尸破防,
	DataManager.BALL_CONFIGS.对天使破防 : 对天使破防,
	DataManager.BALL_CONFIGS.对钢铁破防 : 对钢铁破防,
	DataManager.BALL_CONFIGS.对无属性破防 : 对无属性破防,
	
	DataManager.BALL_CONFIGS.对恶魔降攻 : 对恶魔降攻,
	DataManager.BALL_CONFIGS.对僵尸降攻 : 对僵尸降攻,
	DataManager.BALL_CONFIGS.对天使降攻 : 对天使降攻,
	DataManager.BALL_CONFIGS.对钢铁降攻 : 对钢铁降攻,
	DataManager.BALL_CONFIGS.对无属性降攻 : 对无属性降攻,
}

func _ready() -> void:
	EventBus.enemy_dead.connect(_on_enemy_dead)

func _on_enemy_dead(card: Card) -> void:
	if not is_instance_valid(card):
		return
	if randf() < BASIC_POSSIBILITY:
		create_special_effect_ball(card.global_position)

func create_special_effect_ball(pos: Vector2) -> void:
	var balls_key : Array = balls.keys()
	var ball_res : SpecialEffectBall = balls.get(balls_key.pick_random())
	
	var ball: Ball = BALL_SCENE.instantiate()
	ball.ball_resource = ball_res
	ball.global_position = pos
	
	AduioManager.play(AduioManager.Sound.CREATEBALL)
	var map := get_tree().current_scene
	if map:
		map.add_child(ball)
