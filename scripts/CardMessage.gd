extends Control

@onready var panel: PanelContainer = $PanelContainer
@onready var name_label: Label = $PanelContainer/VBoxContainer/NameLabel
@onready var type_label: Label = $PanelContainer/VBoxContainer/TypeLabel
@onready var mana_label: Label = $PanelContainer/VBoxContainer/ManaBox/ManaLabel
@onready var mana_icon: TextureRect = $PanelContainer/VBoxContainer/ManaBox/TextureRect
@onready var attack_label: Label = $PanelContainer/VBoxContainer/StatsGrid/AttackLabel
@onready var health_label: Label = $PanelContainer/VBoxContainer/StatsGrid/HealthLabel
@onready var speed_label: Label = $PanelContainer/VBoxContainer/StatsGrid/SpeedLabel
@onready var range_label: Label = $PanelContainer/VBoxContainer/StatsGrid/RangeLabel
@onready var target_label: Label = $PanelContainer/VBoxContainer/StatsGrid/TargetLabel
@onready var effects_label: Label = $PanelContainer/VBoxContainer/EffectsLabel
@onready var separator: HSeparator = $PanelContainer/VBoxContainer/HSeparator
@onready var effects_sep: HSeparator = $PanelContainer/VBoxContainer/EffectsSep
@onready var hide_timer: Timer = $HideTimer

const _OFFSETS : int = 16
const HIDE_DELAY := 0.08  # 80ms 延迟隐藏，避免闪烁

const TYPE_NAMES := {
	DataManager.PLAYERTYPE.WALKABLE: "士兵",
	DataManager.PLAYERTYPE.CONSTRUCTION: "建筑",
	DataManager.PLAYERTYPE.MAGIC: "魔法",
}

const EFFECT_NAMES := {
	DataManager.SPECIALEFFECTS.ATTACKDOWN: "攻击降低",
	DataManager.SPECIALEFFECTS.SLOWDOWN: "移速减速",
	DataManager.SPECIALEFFECTS.PAUSEENEMY: "瞬间时停",
	DataManager.SPECIALEFFECTS.BLOCKDOWN: "防御下降",
	DataManager.SPECIALEFFECTS.METALKILLER : "遭受钢铁杀手",
	DataManager.SPECIALEFFECTS.DEMONKILLER : "遭受恶魔杀手",
	DataManager.SPECIALEFFECTS.ANGELKILLER : "遭受天使杀手",
	DataManager.SPECIALEFFECTS.ZOMBINKILLER : "遭受僵尸杀手",
	DataManager.SPECIALEFFECTS.NOATTRIBUTEKILLER : "遭受无属性杀手",
}

const ATTRIBUTE_NAMES := {
	DataManager.ATTRIBUTE.NO : "无属性敌人",
	DataManager.ATTRIBUTE.ZOMBIN : "僵尸敌人",
	DataManager.ATTRIBUTE.ANGEL : "天使敌人",
	DataManager.ATTRIBUTE.DEMON : "恶魔敌人",
	DataManager.ATTRIBUTE.IRON : "钢铁敌人",
}

func _ready() -> void:
	visible = false
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	process_mode = Node.PROCESS_MODE_ALWAYS
	add_to_group("card_message")
	hide_timer.one_shot = true
	hide_timer.timeout.connect(_on_hide_timeout)

func show_card(card_res: CardResource, pos: Vector2) -> void:
	if not card_res:
		return
	# 名称
	name_label.text = card_res.card_name
	# 类型
	type_label.text = "类型: " + TYPE_NAMES.get(card_res.type, "未知")
	# 法力
	mana_label.text = str(card_res.mana)
	# 攻击
	attack_label.text = "攻击: %d" % card_res.attack
	# 生命
	health_label.text = "生命: %d" % card_res.health
	# 速度（仅士兵）
	if card_res.type == DataManager.PLAYERTYPE.WALKABLE:
		speed_label.text = "速度: %d" % card_res.speed
		speed_label.visible = true
	else:
		speed_label.visible = false
	
	# 攻击范围
	range_label.text = "范围: %d" % card_res.attack_range
	
	# 最大目标
	if card_res.max_targets > 0:
		target_label.text = "目标数: %d" % card_res.max_targets
	else:
		target_label.text = "目标数: 全体攻击"
	target_label.visible = true
	
	# 特殊效果
	if card_res.special_effects.is_empty():
		effects_label.visible = false
		effects_sep.visible = false
	else:
		var names: Array[String] = []
		var attribuyes : Array[String] = []
		for e in card_res.special_effects:
			names.append(EFFECT_NAMES.get(e, "?"))
		for a in card_res.target_attribute:
			attribuyes.append(ATTRIBUTE_NAMES.get(a,"?"))
		effects_label.text = "效果: 使" + ",".join(attribuyes) + str(card_res.possibility * 100) + "%概率" + ", ".join(names) + str(card_res.duration / 1000) + "秒"
		effects_label.visible = true
		effects_sep.visible = true
	
	# 定位（跟随鼠标 + 偏移，确保不超出屏幕）
	var final_pos := pos + Vector2(_OFFSETS, _OFFSETS)
	var viewport_size := get_viewport().get_visible_rect().size
	var panel_size := panel.size
	if final_pos.x + panel_size.x > viewport_size.x:
		final_pos.x = pos.x - panel_size.x - _OFFSETS
	if final_pos.y + panel_size.y > viewport_size.y:
		final_pos.y = pos.y - panel_size.y - _OFFSETS
	global_position = final_pos
	
	visible = true
	# 重置定时器：只要持续调用 show_card，定时器就一直被推迟
	hide_timer.start(HIDE_DELAY)

func _on_hide_timeout() -> void:
	visible = false
