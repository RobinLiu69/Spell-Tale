extends Node


var click_sound: AudioStreamPlayer

func _ready():
	
	click_sound = AudioStreamPlayer.new()
	click_sound.name = "ClickPlayer"
	add_child(click_sound)
	
	
	click_sound.stream = preload("res://resources/sounds/button-305770.mp3")  # 根據你的音效路徑調整
	click_sound.volume_db = 0  
