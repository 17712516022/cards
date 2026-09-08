extends Node

signal draw_card(card: CardResource)
signal card_placed(card_res: CardResource, position: Vector2)


signal mana_changed(current: int, max_: int)


signal enemy_base_hurted
signal player_base_hurted

signal base_damaged(base : Node2D)

signal enemy_dead(enemy : Card)
signal ball_collected(ball_res: SpecialEffectBall)
## 装备成功时触发，传递球资源和目标卡牌的键
signal ball_equipped_to_card(ball_res: SpecialEffectBall, card_key: DataManager.USINGCARD)
