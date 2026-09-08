class_name Map extends Node2D

@onready var path: Path2D = %Path
@onready var enemy_spawn: EnemySpawner = %EnemySpawn
@onready var soldier_spawn: Node2D = %SoldierSpawn

var _enemy_progress: Dictionary = {}
var _soldier_progress: Dictionary = {}

func _ready() -> void:
	AduioManager.stop(AduioManager.Sound.PICKCARD)
	AduioManager.play(AduioManager.Sound.BACKGROUND, -8.0)

func _physics_process(delta: float) -> void:
	move_enemy_card(delta)
	move_soldier_card(delta)

func move_enemy_card(delta: float) -> void:
	var curve : Curve2D = path.curve                              # 拿到 Path2D 的曲线对象
	var total_length := curve.get_baked_length()         # 曲线总长度（烘焙后的采样长度）
	for card in enemy_spawn.get_children():              # 遍历敌人生成器下的所有子节点
		if not card is Card:                              # 只处理 Card 类型，跳过其他节点
			continue
		var progress: float = _enemy_progress.get(card, 0.0)  # 取已有进度，新卡从 0（曲线起点）开始
		if card.card_state_machine.TargetCalculater.has_soldier_enemies():      # 遇到士兵 → 停下来打架，不前进
			continue
		progress += card.total_speed * delta
		if progress >= total_length:                           # 走到曲线终点 → 到达基地
			_enemy_progress.erase(card)                         # 清理进度记录                    # 通知掉落
			card.queue_free()                                   # 销毁卡牌
			continue
		_enemy_progress[card] = progress                       # 保存当前进度
		card.global_position = curve.sample_baked(progress)    # 把卡牌放到曲线上对应位置

func move_soldier_card(delta: float) -> void:
	var curve := path.curve
	var total_length := curve.get_baked_length()
	for card in soldier_spawn.get_children():
		if not card is Card:
			continue
		var progress: float = _soldier_progress.get(card, total_length)
		if card.card_state_machine.has_enemies():
			continue
		progress -= card.total_speed * delta
		if progress <= 0.0:
			_soldier_progress.erase(card)
			card.queue_free()
			continue
		_soldier_progress[card] = progress
		card.global_position = curve.sample_baked(progress)
