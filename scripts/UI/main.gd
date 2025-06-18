extends Node2D

@onready var main_menu: Control = $MarginContainer/MainMenu


func _ready() -> void:
	main_menu.visible = true
	AudioManager.play_bgm()
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(Global.master_volume))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(Global.music_volume))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Effect"), linear_to_db(Global.effect_volume))
