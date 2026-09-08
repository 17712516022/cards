extends Node

enum SPECIALEFFECTS{
	ATTACKDOWN,SLOWDOWN,PAUSEENEMY,BLOCKDOWN,METALKILLER,DEMONKILLER,ANGELKILLER,ZOMBINKILLER,NOATTRIBUTEKILLER,
}

enum ATTRIBUTE {
	NO,ZOMBIN,ANGEL,DEMON,IRON
}

enum PLAYERTYPE {
	MAGIC,CONSTRUCTION,WALKABLE
}

enum USINGENEMY {
	僵尸剑士,僵尸战桨队,僵尸死亡小丑,僵尸歼灭团, 僵尸猛枪战队, 
	天使剑士,天使弓箭, 天使战桨队,天使死亡小丑, 
	恶魔剑士,恶魔弓箭, 恶魔战桨队,恶魔歼灭团,
	无属性剑士,无属性地藏,无属性弓箭,无属性战桨队, 无属性死亡小丑,无属性歼灭团,无属性猛枪战队, 
	钢铁剑士,钢铁地藏,钢铁战桨队, 钢铁死亡小丑
}

enum USINGCARD {
	JIAN,地藏,战桨队,空帝雷,弓箭手,天龙城,时空神,
	勇者斗恶龙,影杰,死亡小丑,英杰,
	异灭堂,妖贤女,雷电,黑帝丝,古代石板,
	非命,猛枪战队,铁精灵,大魔导师,歼灭团,
	天命,
}

enum BALL_CONFIGS {
	僵尸杀手球,钢铁杀手球,无属性杀手,恶魔杀手,天使杀手,
	对僵尸时停,对钢铁时停,对无属性时停,对恶魔时停,对天使时停,
	对僵尸减速,对钢铁减速,对无属性减速,对恶魔减速,对天使减速,
	对僵尸降攻,对钢铁降攻,对无属性降攻,对恶魔降攻,对天使降攻,
	对僵尸破防,对钢铁破防,对无属性破防,对恶魔破防,对天使破防,
}

## 属性脚本映射：ATTRIBUTE 枚举 → 对应脚本
const AttributeScripts := {
	ATTRIBUTE.NO:     preload("res://scripts/EnemyAttribute/AttributeNo.gd"),
	ATTRIBUTE.IRON:   preload("res://scripts/EnemyAttribute/AttributeIron.gd"),
	ATTRIBUTE.ZOMBIN: preload("res://scripts/EnemyAttribute/AttributeZombin.gd"),
	ATTRIBUTE.ANGEL:  preload("res://scripts/EnemyAttribute/AttributeAngel.gd"),
	ATTRIBUTE.DEMON:  preload("res://scripts/EnemyAttribute/AttributeDemon.gd"),
}
