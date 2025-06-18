extends Node

var click_sound: AudioStreamPlayer
var bgm_player: AudioStreamPlayer
var battle_player: AudioStreamPlayer

func _ready():
	# button click
	click_sound = AudioStreamPlayer.new()
	click_sound.name = "ClickPlayer"
	click_sound.bus = "Effect"
	add_child(click_sound)
	click_sound.stream = preload("res://resources/sounds/buttons/button-305770.mp3")
	click_sound.volume_db = 0

	# menu BGM
	bgm_player = AudioStreamPlayer.new()
	bgm_player.name = "BGMPlayer"
	bgm_player.bus = "Music"
	bgm_player.autoplay = false
	bgm_player.volume_db = 0
	add_child(bgm_player)
	bgm_player.stream = preload("res://resources/sounds/music/jazz-bossa-nova-cooking-show-music-312826.mp3")
	bgm_player.stream.loop = true

	# battle BGM
	battle_player = AudioStreamPlayer.new()
	battle_player.name = "BattlePlayer"
	battle_player.bus = "Music"
	battle_player.autoplay = false
	battle_player.volume_db = 0
	add_child(battle_player)
	battle_player.stream = preload("res://resources/sounds/music/corsairs-studiokolomna-main-version-23542-02-33.mp3")
	battle_player.stream.loop = true
	
	
func play_click_sound():
	click_sound.play()

func play_bgm() -> void:
	if battle_player.playing:
		battle_player.stop()
	if bgm_player.playing:
		return
	bgm_player.play()

func play_battle_music() -> void:
	if bgm_player.playing:
		bgm_player.stop()
	battle_player.play()

func stop_music() -> void:
	bgm_player.stop()
	battle_player.stop()
