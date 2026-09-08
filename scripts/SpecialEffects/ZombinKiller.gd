## 僵尸杀手特殊效果 — 被攻击的僵尸敌人失去复活能力
## 效果：目标被标记后，僵尸血量归零时跳过 AttributeZombin.try_revive()，直接死亡
class_name ZombinKiller extends Node2D

var card : Card

## 激活：标记目标，使其无法触发僵尸复活
func activate(context_card: Card) -> void:
	if not is_instance_valid(context_card):
		return
	card = context_card
	card.ignore_zombin_revive = true

## 反激活：清除标记，僵尸复活恢复正常
func deactivate() -> void:
	if is_instance_valid(card):
		card.ignore_zombin_revive = false

func ball_activate(ball_res : SpecialEffectBall,context_card : Card) -> void :
	activate(context_card)
