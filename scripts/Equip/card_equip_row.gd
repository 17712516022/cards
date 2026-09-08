## 装备面板右侧的一行：卡牌信息 + 已装备球列表
## 每张可使用卡牌对应一行，左侧显示卡牌名称和类型，右侧横排显示已装备的特殊效果球。
## 也是 BallInvItem 拖拽装备的目标节点。
class_name CardEquipRows extends HBoxContainer

const TEXTURE_SIZE : Vector2 = Vector2(64,64)

## 当前行对应的卡牌资源
var card_res: CardResource
## 卡牌在 DataManager 中的键（标识是哪张卡）
var card_key: DataManager.USINGCARD

## 初始化行控件
## @param key: 卡牌在 USINGCARD 枚举中的键
## @param res: 卡牌资源对象
func setup(key: DataManager.USINGCARD, res: CardResource) -> void:
	card_key = key
	card_res = res
	# 固定最小高度，保持表格行高一致
	custom_minimum_size = Vector2(0, 58)
	_build_ui()

func _ready() -> void:
	EventBus.ball_equipped_to_card.connect(_on_equiped_to_card.bind())

## 获取当前行的卡牌资源（供 BallInvItem 拖拽命中时查询）
## @return: CardResource 对象
func get_card_resource() -> CardResource:
	return card_res


## 检查是否可以接受新的装备球
## @return: 已装备球数量 < 3 时返回 true（每张卡最多装3个球）
func can_accept_ball() -> bool:
	return card_res.equipped_balls.size() < 3


## 构建 UI 布局：背景底板 + 卡牌名称 + 类型标签 + 装备球横向容器
func _build_ui() -> void:
	# 背景底板
	var bg := ColorRect.new()
	bg.name = "bg"
	bg.size = Vector2(420, 56)
	bg.color = Color(0.08, 0.08, 0.11, 1)  # 深色背景
	add_child(bg)
	
	var text := TextureRect.new()
	text.texture = card_res.tetxure
	text.custom_minimum_size = TEXTURE_SIZE
	add_child(text)
	
	
func _on_equiped_to_card(ball_res: SpecialEffectBall, target_key: DataManager.USINGCARD) -> void:
	if target_key != card_key:
		return
	var ballui_texture : TextureRect = TextureRect.new()
	if ball_res.texture != null:
		ballui_texture.texture = ball_res.texture
		ballui_texture.modulate = ball_res.modulate
	ballui_texture.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ballui_texture.custom_maximum_size = TEXTURE_SIZE
	add_child(ballui_texture)
