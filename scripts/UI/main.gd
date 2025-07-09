extends Node2D

@onready var main_menu: Control = $MarginContainer/MainMenu
@export var full_screen: bool = true

func _ready() -> void:
	Global.apply_keybindings()
	if full_screen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		Global.fullscreen_status = true
		
	main_menu.visible = true
	AudioManager.play_bgm()
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(Global.master_volume))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(Global.music_volume))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Effect"), linear_to_db(Global.effect_volume))
