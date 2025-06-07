class_name Setting
extends Control

@onready var video_setting: VBoxContainer = $mainscreen/SettingBackground/Buttoncontainer/VBoxContainer/VideoSetting
@onready var audio_setting: VBoxContainer = $mainscreen/SettingBackground/Buttoncontainer/VBoxContainer/AudioSetting
@onready var graph_setting: VBoxContainer = $mainscreen/SettingBackground/Buttoncontainer/VBoxContainer/Graphsetting
@onready var misc_setting: VBoxContainer = $mainscreen/SettingBackground/Buttoncontainer/VBoxContainer/MISCsetting
@export var audio_bus_name: String



func _on_leave_button_pressed() -> void:
	if Global.previous_scene_path == "res://scenes/main.tscn":
		get_tree().change_scene_to_file("res://scenes/main.tscn")
		return
	queue_free()
	if Global.previous_scene_path == "res://scenes/training_room.tscn":
		get_tree().paused = Global.pause_status

	
	

	
func _on_video_button_pressed() -> void:
	video_setting.visible = true
	audio_setting.visible = false
	graph_setting.visible = false
	misc_setting.visible = false

func _on_audio_button_pressed() -> void:
	video_setting.visible = false
	audio_setting.visible = true
	graph_setting.visible = false
	misc_setting.visible = false
	
	

func _on_graph_button_pressed() -> void:
	video_setting.visible = false
	audio_setting.visible = false
	graph_setting.visible = true
	misc_setting.visible = false
	
func _on_misc_button_pressed() -> void:
	video_setting.visible = false
	audio_setting.visible = false
	graph_setting.visible = false
	misc_setting.visible = true



func _on_volumesetting_value_changed(value: float) -> void:
	print(value)
	AudioServer.set_bus_volume_db(0,value)
	

func _on_resolution_option_item_selected(index: int) -> void:
	match index:
		0: 
			DisplayServer.window_set_size(Vector2i(1920,1080))
		1:
			DisplayServer.window_set_size(Vector2i(1600,900))
		2: 
			DisplayServer.window_set_size(Vector2i(1280,720))



func _on_screen_mode_2_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
		3:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
			
