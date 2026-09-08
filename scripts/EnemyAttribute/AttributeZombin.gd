class_name AttributeZombin extends Node

var enemy : Card
var _has_revived: bool = false
var _pending_revive: bool = false

func SetUp(context_enemy : Card) -> void:
	enemy = context_enemy

## 尝试复活：首次死亡冻结 10 秒后恢复血量
func try_revive() -> bool:
	if _has_revived or _pending_revive:
		return false
	_pending_revive = true
	enemy.is_reviving = true   # 复活期间不可被选为攻击目标（TargetCalculate 统一过滤）
	enemy.set_physics_process(false)
	enemy.speed_multiplier = 0.0
	_start_revive_timer()
	return true

func _start_revive_timer() -> void:
	await enemy.get_tree().create_timer(10.0).timeout
	if not is_instance_valid(enemy):
		return
	_has_revived = true
	_pending_revive = false
	enemy.health = enemy.card_resource.health   # 先回血
	enemy.is_reviving = false                    # 再恢复为可被攻击目标
	enemy.set_physics_process(true)
	enemy.speed_multiplier = 1.0
