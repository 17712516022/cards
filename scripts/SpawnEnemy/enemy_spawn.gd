class_name EnemySpawner extends Node2D

## 第一波延迟时间（秒），让玩家有准备时间
@export var first_wave_delay: float = 5.0
## 后续每波之间的间隔时间（秒）
@export var wave_interval: float = 30.0
## 两个敌人之间的生成间隔（秒），> 0 时分帧生成，避免同帧卡顿
@export var spawn_interval: float = 2

@onready var enemy_spawn_manager: EnemySpawnManager = $EnemySpawnManager

## 卡牌场景
const CARD_SCENE := preload("res://scene/card.tscn")
## 敌人小队场景
const Squad := preload("res://scene/squad_enemy.tscn")
## 卡牌工厂，用于创建敌人的 EnemyCardResource 数据
var card_factory: CardFactory
## 当前波次待生成的敌人类型队列（FIFO）
var _spawn_queue: Array = []
## 距下一个敌人可生成的冷却时间，倒计时减到 0 时生成一个敌人
var _spawn_cooldown: float = 0.0
## 波次 Timer 引用，用于首波后切换间隔时间
var _wave_timer: Timer

func _ready() -> void:
	# 在 _ready 中初始化工厂，避免在声明处直接 new 可能引发的问题
	card_factory = CardFactory.new()
	# 启动波次计时器
	_start_spawn_cycle()

## 每物理帧检查是否有待生成的敌人，按 spawn_interval 间隔逐个产出。
## 当前波全部出完后，启动 Timer 开始下一波倒计时。
func _physics_process(delta: float) -> void:
	if not _spawn_queue.is_empty():
		_spawn_cooldown -= delta
		if _spawn_cooldown <= 0.0:
			# 从队列头部取出一个敌人类型并生成
			var type: DataManager.USINGENEMY = _spawn_queue.pop_front()
			spawn_enemy(type)
			# 重置冷却，下一次生成要等 spawn_interval 秒
			_spawn_cooldown = spawn_interval

			# 当前波全部出完，启动下一波倒计时
			if _spawn_queue.is_empty():
				_wave_timer.start(wave_interval)

## 创建 Timer，首次 first_wave_delay 秒后触发第一波。
## 后续每波在上一波全部出完后，由 _physics_process 启动倒计时。
func _start_spawn_cycle() -> void:
	_wave_timer = Timer.new()
	_wave_timer.wait_time = first_wave_delay   # 首波延迟
	_wave_timer.one_shot = true                # 每次只触发一次，由代码手动重启
	_wave_timer.autostart = true               # 创建后自动开始
	add_child(_wave_timer)
	_wave_timer.timeout.connect(_on_spawn_wave)

## Timer 超时回调：从 Manager 获取本波敌人配置并填入生成队列。
func _on_spawn_wave() -> void:
	var enemies: Array[EnemyGroup] = enemy_spawn_manager.request_wave_enemies()
	if enemies.is_empty():
		return  # 没有更多波次，停止生成
	for group: EnemyGroup in enemies:
		for i in range(group.count):
			_spawn_queue.append(group.type)
	# 第一帧就立即可生成，无需等待
	_spawn_cooldown = 0.0

## 实例化一个敌人并加入场景树
## @param new_enemy: 敌人类型枚举，决定生成的单位种类
func spawn_enemy(new_enemy: DataManager.USINGENEMY) -> void:
	# 1. 通过工厂创建敌人数据资源的副本（不污染共享 .tres）
	var enemy_res: EnemyCardResource = card_factory.create_enemy_card(new_enemy).duplicate()
	
	var mult := enemy_spawn_manager.get_cycle_multiplier()
	enemy_res.health = int(enemy_res.health * mult)
	enemy_res.attack = int(enemy_res.attack * mult)
	
	# 2. 实例化卡牌节点并绑定数据
	var enemy: Card = CARD_SCENE.instantiate()
	enemy.card_resource = enemy_res
	enemy.modulate = enemy_res.modulate
	
	# 3. 添加小队节点，并根据属性挂载对应的 attribute 节点
	var squad: Node2D = Squad.instantiate()
	attach_attribute(squad,CardFactory._create_attribute(enemy_res.attribute))
	enemy.add_child(squad)
	squad.SetUp(enemy)
	
	# 4. 设置出生位置
	enemy.global_position = self.global_position

	# 5. 将敌人加入场景
	add_child(enemy)

func attach_attribute(squad,script : Script) -> void:
	var attribute_node := Node.new()
	attribute_node.set_script(script)
	squad.add_child(attribute_node)
