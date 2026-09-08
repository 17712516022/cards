class_name Card extends AnimatableBody2D

var card_resource   ## CardResource 或 EnemyCardResource
@onready var hit_box: Area2D = %HitBox
@onready var cardtexture: Sprite2D = %cardtexture
@onready var card_state_machine: CardStateMachine = %CardStateMachine
@onready var card_animation_player: AnimationPlayer = %CardAnimationPlayer
@onready var gpu_particles_2d: GPUParticles2D = %GPUParticles2D
@onready var dietexture: Sprite2D = %dietexture

# ── 效果节点（Card 场景中预建，默认失活） ──
@onready var special_effects: EffectComponent = %SpecialEffects
@onready var enemysquad := get_node_or_null("SquadEnemy")
@onready var playersquad := get_node_or_null("SquadPlayer")

var total_speed: float:
	get:
		return speed_multiplier * card_resource.speed

var total_attack: float:
	get:
		return attack_value * attack_multiplier

var ignore_iron_shield: bool = false     ## MetalKiller 标记：true 时伤害无视钢铁护盾
var ignore_demon_poison: bool = false   ## DemonKiller 标记：true 时免疫恶魔毒击
var ignore_angel_effect : bool = false
var ignore_zombin_revive: bool = false  ## ZombinKiller 标记：true 时僵尸无法复活
var noattack_multiplier: float = 1.0    ## NoAttributeKiller：攻击者对无属性目标的伤害倍率（默认1.0即无加成）
var is_reviving: bool = false           ## 僵尸复活中：true 时不可被选为攻击目标（由 AttributeZombin 维护）

var health : float
var attack_value : float 
var attack_coolingdown : float
var speed_multiplier: float = 1.0             ## 移动修正系数，实际速度 = resource.speed * 此值
var attack_multiplier: float = 1.0            ## 攻击修正系数，实际攻击 = resource.attack * 此值
var hurt_multiplier : float = 1.0

var CardEffectapplier : CardEffectApplier = CardEffectApplier.new()

var _is_player: bool

func _ready() -> void:
	if card_resource.tetxure:
		cardtexture.texture = card_resource.tetxure
	_is_player = has_node("SquadPlayer")
	InitCard()
	card_state_machine.setup(self,card_animation_player)
	
	hit_box.body_entered.connect(_on_body_entered)
	hit_box.body_exited.connect(_on_body_exited)
	
	special_effects.SetUp(self)
	CardEffectapplier.SetUp(card_resource)

func InitCard() -> void:
	# 复制 shape，避免修改共享资源影响其他卡片
	hit_box.get_child(0).shape = hit_box.get_child(0).shape.duplicate()
	hit_box.get_child(0).shape.radius = card_resource.attack_range
	health = card_resource.health
	attack_value = card_resource.attack
	attack_coolingdown = card_resource.attack_coolingdown * 1000.0

	# 效果节点默认静默，攻击时在目标身上触发

func _physics_process(_delta: float) -> void:
	card_state_machine.update()
	
# ── 敌人追踪 ──
func _on_body_entered(body: Node2D) -> void:
	card_state_machine.TargetCalculater.add_enemy(body)

func _on_body_exited(body: Node2D) -> void:
	card_state_machine.TargetCalculater.remove_enemy(body)

func _is_valid_target(body: Node2D) -> bool:
	if not body is Card:
		return false
	var target_is_enemy := body.has_node("SquadEnemy")
	return (_is_player and target_is_enemy) or (not _is_player and not target_is_enemy)

var _last_hurt_time: int = 0

func take_damage(value: float) -> void:
	if card_state_machine.current_state is CardStateDead:
		return
	
	AduioManager.play(AduioManager.Sound.HURT)
	var total_hurt : float = hurt_multiplier * value
	# MetalKiller 无视钢铁护盾：跳过盾吸收，伤害直接扣血量
	if not ignore_iron_shield:
		total_hurt = AttributeManager._shield_absorb_damage(card_resource, enemysquad, total_hurt)
	
	health = maxf(health - total_hurt, 0.0)
	
	# 350ms 冷却，避免受伤动画被高频重置而看起来卡住
	var now := Time.get_ticks_msec()
	
	if health <= 0.0:
		# ZombinKiller 无视僵尸复活：标记时跳过复活，直接死亡
		if not ignore_zombin_revive and AttributeManager._try_revive(card_resource,enemysquad):
			return
		card_state_machine.transition_to(CardStateDead.new())
		return
		
	if now - _last_hurt_time > 350:
		_last_hurt_time = now
		gpu_particles_2d.emitting = true
