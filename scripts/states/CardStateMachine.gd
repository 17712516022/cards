class_name CardStateMachine extends Node

var card: Card
var current_state: CardState
var last_attack_time: float = 0
var card_animation_player : AnimationPlayer

var TargetCalculater : TargetCalculate

# 状态缓存（复用避免反复 new 造成 GC 抖动）
var _state_idle := CardStateIdle.new()
var _state_attacking := CardStateAttacking.new()
var _state_dead := CardStateDead.new()

func setup(context_card: Card ,context_card_animation_player : AnimationPlayer) -> void:
	card = context_card
	card_animation_player = context_card_animation_player
	transition_to(_state_idle)
	
	TargetCalculater = TargetCalculate.new()
	TargetCalculater.SetUp(card)
	
func update() -> void:
	current_state.update(self)

func transition_to(new_state: CardState) -> void:
	if current_state is CardStateDead:
		return
	if current_state and current_state.get_script() == new_state.get_script():
		return
	if current_state:
		current_state.exit(self)
	current_state = new_state
	current_state.enter(self)

# ── 敌人管理 ──
func has_enemies() -> bool:
	return TargetCalculater.has_targetable_enemies()
	
# ── 攻击 ──
func reset_attack_timer() -> void:
	last_attack_time = Time.get_ticks_msec()

func can_attack() -> bool:
	return Time.get_ticks_msec() - last_attack_time >= card.attack_coolingdown

func do_attack() -> void:
	last_attack_time = Time.get_ticks_msec()
	TargetCalculater.clean_enemies()  # 先清除过期引用
	var targets := _get_attack_targets()
	for enemy in targets:
		if not is_instance_valid(enemy):
			continue
		if not enemy is Card:
			continue
		
		# ◆ 先施加装备球效果（让 ignore_iron_shield、noattack_multiplier 等标记先生效）
		card.CardEffectapplier.apply_ball_effects(card, enemy)
		
		if enemy.has_method("take_damage"):
			# NoAttributeKiller：攻击者对无属性敌人造成额外伤害
			var dmg : float = card.total_attack
			if enemy.card_resource is EnemyCardResource and enemy.card_resource.attribute == DataManager.ATTRIBUTE.NO:
				dmg *= card.noattack_multiplier
			enemy.take_damage(dmg)
		
		card.CardEffectapplier.trigger_attack_effects(enemy,card.card_resource.special_effects)
		if not enemy.ignore_angel_effect:
			AttributeManager._angel_activate_random_enemy_effect(card.card_resource, card.enemysquad, enemy)
		# DemonKiller 免疫：目标被标记时跳过恶魔毒击
		if not enemy.ignore_demon_poison:
			AttributeManager._demon_poison_attack(card.card_resource, card.enemysquad, enemy)

## 获取实际攻击目标列表（按距离排序，受 max_targets 限制）
func _get_attack_targets() -> Array[Node2D]:
	# 复活中的僵尸不算目标（成员关系保留，复活完成后自动恢复可被攻击）
	var available: Array[Node2D] = []
	for enemy in TargetCalculater.enemies_in_range:
		if TargetCalculate._is_targetable(enemy):
			available.append(enemy)
	if card.card_resource.max_targets <= 0:
		# max_targets=0 → 群体攻击，攻击范围内所有敌人
		return available
	# 单体/限目标：按距离排序，选最近的 N 个
	available.sort_custom(_sort_by_distance)
	return available.slice(0, card.card_resource.max_targets)

func _sort_by_distance(a: Node2D, b: Node2D) -> bool:
	return card.global_position.distance_squared_to(a.global_position) < card.global_position.distance_squared_to(b.global_position)

# ── 死亡 ──
func disable_card() -> void:
	card.set_physics_process(false)
	
	card.cardtexture.visible = false
	card.dietexture.visible = true
	
	# 解除动画暂停（防止 EffectPauseEnemy 导致的死锁）
	card.card_animation_player.stop()
	card.card_animation_player.play("die")
	var elapsed := 0.0
	const DIE_TIMEOUT := 3.0
	while card.card_animation_player.is_playing() and elapsed < DIE_TIMEOUT:
		await card.get_tree().process_frame
		elapsed += card.get_process_delta_time()
	
	if card.enemysquad :
		EventBus.enemy_dead.emit(card)
	
	card.queue_free()
