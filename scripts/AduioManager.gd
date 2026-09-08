extends Node

enum Sound {
	BACKGROUND,PICKCARD,HURT,USECARD,DRAWCARD,DISCORDCARD,EQUIP,
	CREATEBALL,BASEHURT
}

const CHANNALS:int = 16 #音频通道数量

const SFX_MAP:Dictionary = {
	Sound.BACKGROUND : preload("res://aduio/纸塔守阵.mp3"),
	Sound.PICKCARD : preload("res://aduio/纸牌静阵.mp3"),
	Sound.HURT : preload("res://aduio/hurt.wav"),
	Sound.USECARD : preload("res://aduio/whistle.wav"),
	Sound.DRAWCARD : preload("res://aduio/bounce.wav"),
	Sound.DISCORDCARD : preload("res://aduio/tackle.wav"),
	Sound.EQUIP : preload("res://aduio/power-shot.wav"),
	Sound.CREATEBALL : preload("res://aduio/shoot.wav"),
	Sound.BASEHURT : preload("res://aduio/pass.wav")
}

var stream_players : Array[AudioStreamPlayer] = []#音频流播放器

func _ready() -> void:
	for i in CHANNALS:
		var stream_player : AudioStreamPlayer = AudioStreamPlayer.new()
		stream_players.append(stream_player)
		add_child(stream_player)

#寻找可用播放器
func find_avaliable_streamplayer() -> AudioStreamPlayer:
	for stream_player in stream_players:
		if not stream_player.playing:#如果没有在播放
			return stream_player
	
	return null

## 音量（分贝），0.0 = 原始音量，负值降低，正值提高
func play(sound: Sound, volume_db: float = 0.0) -> void:
	var stream_player := find_avaliable_streamplayer()
	if stream_player != null:
		stream_player.volume_db = volume_db
		stream_player.stream = SFX_MAP[sound]
		stream_player.play()

func stop(sound : Sound) -> void:
	for player in stream_players:
		if player.playing and player.stream == SFX_MAP[sound]:
			player.stop()
