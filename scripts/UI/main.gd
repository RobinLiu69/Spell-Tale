extends Node2D

@onready var main_menu: Control = $MarginContainer/MainMenu


func _ready() -> void:
	if Global.fullscreen_status:
		pass
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		Global.fullscreen_status = true
	main_menu.visible = true
	AudioManager.play_bgm()
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(Global.master_volume))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(Global.music_volume))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Effect"), linear_to_db(Global.effect_volume))
