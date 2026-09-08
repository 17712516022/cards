class_name CardFactory extends Node

# ── 玩家卡牌资源 ──
const JIAN = preload("uid://rqojat8176fv")
const 地藏 = preload("uid://blcys5ndk4bc5")
const 战桨队 = preload("uid://oh7s417cqpgx")
const 空帝雷 = preload("uid://wtd6xau0gfeo")
const 天龙城 = preload("uid://dgsnje2aemn4g")
const 弓箭手 = preload("uid://baycjwq7dhjrh")
const 时空神 = preload("uid://guc1y3h8j1n5")
const 勇者斗恶龙 = preload("uid://c5fuaopsi885i")
const 影杰 = preload("uid://cxua2bkbjos2l")
const 死亡小丑 = preload("uid://bnlx0ocggskyw")
const 英杰 = preload("uid://d005eg5pp8nh5")
const 古代石板 = preload("uid://7stmfunk22m3")
const 妖贤女 = preload("uid://dyvgusvyujy8x")
const 异灭堂 = preload("uid://bu5jdt7b433io")
const 雷电 = preload("uid://0svld55ligxd")
const 黑帝丝 = preload("uid://ca4wx3agqrihu")
const 铁精灵 = preload("uid://b7tgtjva2d602")
const 非命 = preload("uid://dwdx54xms7j0a")
const 大魔导师 = preload("uid://cc0c7gye8ang2")
const 歼灭团 = preload("uid://bbfx0sdvxxwyy")
const 猛枪战队 = preload("uid://bpanus0v573ie")
const 天命 = preload("uid://csag7udo73rtc")

# ── 敌人卡牌资源 ──
const 僵尸剑士 = preload("uid://vqi1jpnli2im")
const 僵尸战桨队 = preload("uid://cqb02iv7sv6xj")
const 僵尸死亡小丑 = preload("uid://uw5icv0krpj1")
const 僵尸歼灭团 = preload("uid://ckpq852yn3bqs")
const 僵尸猛枪战队 = preload("uid://c2u4f33ptpyud")
const 天使剑士 = preload("uid://c8xsq2bqw2xxu")
const 天使弓箭 = preload("uid://u0gisc83seuu")
const 天使战桨队 = preload("uid://b6nppktqgl4rm")
const 天使死亡小丑 = preload("uid://bkqqm8f1n7s4m")
const 恶魔剑士 = preload("uid://bpvntowjflfpa")
const 恶魔弓箭 = preload("uid://dgussecfu117f")
const 恶魔战桨队 = preload("uid://5l6vliq2bk71")
const 恶魔歼灭团 = preload("uid://bf8ylvsoefxnm")
const 无属性剑士 = preload("uid://dggq4d54apsje")
const 无属性地藏 = preload("uid://b744akxeh72m2")
const 无属性弓箭 = preload("uid://r0g5srx0j5w2")
const 无属性战桨队 = preload("uid://dpvvfpkdskaf0")
const 无属性死亡小丑 = preload("uid://ck1qxgoap73u4")
const 无属性歼灭团 = preload("uid://cb2jb4m47dmji")
const 无属性猛枪战队 = preload("uid://jb1qtyfw4ott")
const 钢铁剑士 = preload("uid://bkgmtrpmule52")
const 钢铁地藏 = preload("uid://c6gkl2m65t3ol")
const 钢铁战桨队 = preload("uid://llti61bb0mqm")
const 钢铁死亡小丑 = preload("uid://dsqyx1uhql5md")


var cards : Dictionary = {
	DataManager.USINGCARD.JIAN : JIAN,
	DataManager.USINGCARD.地藏 : 地藏,
	DataManager.USINGCARD.战桨队 : 战桨队,
	DataManager.USINGCARD.空帝雷 : 空帝雷,
	DataManager.USINGCARD.弓箭手 : 弓箭手,
	DataManager.USINGCARD.天龙城 : 天龙城,
	DataManager.USINGCARD.时空神 : 时空神,
	DataManager.USINGCARD.勇者斗恶龙 : 勇者斗恶龙,
	DataManager.USINGCARD.影杰 : 影杰,
	DataManager.USINGCARD.英杰 : 英杰,
	DataManager.USINGCARD.死亡小丑 : 死亡小丑,
	DataManager.USINGCARD.古代石板 : 古代石板,
	DataManager.USINGCARD.妖贤女 : 妖贤女,
	DataManager.USINGCARD.异灭堂 : 异灭堂,
	DataManager.USINGCARD.雷电 : 雷电,
	DataManager.USINGCARD.黑帝丝 : 黑帝丝,
	DataManager.USINGCARD.铁精灵 : 铁精灵,
	DataManager.USINGCARD.非命 : 非命,
	DataManager.USINGCARD.大魔导师 : 大魔导师,
	DataManager.USINGCARD.歼灭团 : 歼灭团,
	DataManager.USINGCARD.猛枪战队 : 猛枪战队,
	DataManager.USINGCARD.天命 : 天命,
}

## 玩家当前装备的卡组（战斗中小只能抽这些）
var deck: Array[DataManager.USINGCARD] = []
const MAX_DECK_SIZE := 10

var enemy_cards : Dictionary = {
	DataManager.USINGENEMY.僵尸剑士 : 僵尸剑士,
	DataManager.USINGENEMY.僵尸战桨队 : 僵尸战桨队,
	DataManager.USINGENEMY.僵尸死亡小丑 : 僵尸死亡小丑,
	DataManager.USINGENEMY.僵尸歼灭团 : 僵尸歼灭团,
	DataManager.USINGENEMY.僵尸猛枪战队 : 僵尸猛枪战队,
	DataManager.USINGENEMY.天使剑士 : 天使剑士,
	DataManager.USINGENEMY.天使弓箭 : 天使弓箭,
	DataManager.USINGENEMY.天使战桨队 : 天使战桨队,
	DataManager.USINGENEMY.天使死亡小丑 : 天使死亡小丑,
	DataManager.USINGENEMY.恶魔剑士 : 恶魔剑士,
	DataManager.USINGENEMY.恶魔弓箭 : 恶魔弓箭,
	DataManager.USINGENEMY.恶魔战桨队 : 恶魔战桨队,
	DataManager.USINGENEMY.恶魔歼灭团 : 恶魔歼灭团,
	DataManager.USINGENEMY.无属性剑士 : 无属性剑士,
	DataManager.USINGENEMY.无属性地藏 : 无属性地藏,
	DataManager.USINGENEMY.无属性弓箭 : 无属性弓箭,
	DataManager.USINGENEMY.无属性战桨队 : 无属性战桨队,
	DataManager.USINGENEMY.无属性死亡小丑 : 无属性死亡小丑,
	DataManager.USINGENEMY.无属性歼灭团 : 无属性歼灭团,
	DataManager.USINGENEMY.无属性猛枪战队 : 无属性猛枪战队,
	DataManager.USINGENEMY.钢铁剑士 : 钢铁剑士,
	DataManager.USINGENEMY.钢铁地藏 : 钢铁地藏,
	DataManager.USINGENEMY.钢铁战桨队 : 钢铁战桨队,
	DataManager.USINGENEMY.钢铁死亡小丑 : 钢铁死亡小丑,
}

## 将一张卡加入卡组
func add_to_deck(card: DataManager.USINGCARD) -> bool:
	if deck.has(card):
		return false
	if deck.size() >= MAX_DECK_SIZE:
		return false
	if not cards.has(card):
		return false
	deck.append(card)
	return true

## 从卡组移除一张卡
func remove_from_deck(card: DataManager.USINGCARD) -> bool:
	var idx := deck.find(card)
	if idx == -1:
		return false
	deck.remove_at(idx)
	return true

## 卡组里是否已有这张卡
func is_in_deck(card: DataManager.USINGCARD) -> bool:
	return deck.has(card)

## 从卡组随机抽一张卡
func draw_random_from_deck() -> DataManager.USINGCARD:
	if deck.is_empty():
		push_warning("[CardFactory] 卡组为空，无法抽牌！")
		return cards.keys()[0]  # fallback
	return deck[randi() % deck.size()]

func create_card(new_card) -> CardResource:
	return cards[new_card]

func create_enemy_card(new_enemy) -> EnemyCardResource:
	return enemy_cards[new_enemy]

## 根据属性枚举创建对应的 attribute 节点并挂到 squad 下
static func _create_attribute(attr: DataManager.ATTRIBUTE) -> Script:
	var script : Script = DataManager.AttributeScripts.get(attr)
	if not script:
		push_warning("[EnemySpawn] 未知敌人属性: ", attr)
		return
	return script
