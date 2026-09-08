class_name EnemySpawnManager extends Node

## 波次配置：决定每一波生成什么类型、多少敌人
## 在 Inspector 中添加 WaveConfig 元素，每个 WaveConfig 内可添加多个 EnemyGroup
@export var wave_configs: Array[WaveConfig] = []

## 当前波次索引（0 起始，在 wave_configs 范围内循环）
var _current_wave: int = 0
## 当前循环次数（0 = 首次完整遍历，1 = 第二次...）
var _current_cycle: int = 0

## 获取当前循环的数值倍率
## 第 1 次循环 = 1.0 (100%)，第 2 次 = 2.0 (200%)，第 3 次 = 3.0 (300%) ...
func get_cycle_multiplier() -> float:
	return 1.0 + float(_current_cycle)

## 由 EnemySpawner 调用，获取当前波次应生成的敌人列表
## 波次超出配置范围时自动回到第一波，并进入下一循环
## 返回 Array[EnemyGroup]
func request_wave_enemies() -> Array[EnemyGroup]:
	if wave_configs.is_empty():
		printerr("EnemySpawnManager: wave_configs 为空！")
		return []

	# 波次索引超出范围 → 循环回第一波，倍率升级
	if _current_wave >= wave_configs.size():
		_current_wave = 0
		_current_cycle += 1
	
	var wave: WaveConfig = wave_configs[_current_wave]
	_current_wave += 1
	return wave.enemies
