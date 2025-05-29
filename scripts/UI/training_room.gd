extends Node2D

@onready var menucontainer: MarginContainer = $CanvasLayer/Menucontainer
@onready var main_screen: MarginContainer = $MainScreen
@onready var video_setting: VBoxContainer = $CanvasLayer/SettingScreen/SettingBackgroundTexture/MarginContainer/VBoxContainer/VideoSetting
@onready var audio_setting: VBoxContainer = $CanvasLayer/SettingScreen/SettingBackgroundTexture/MarginContainer/VBoxContainer/AudioSetting
@onready var graph_setting: VBoxContainer = $CanvasLayer/SettingScreen/SettingBackgroundTexture/MarginContainer/VBoxContainer/GraphSetting
@onready var misc_setting: VBoxContainer = $CanvasLayer/SettingScreen/SettingBackgroundTexture/MarginContainer/VBoxContainer/MISCSetting
@onready var setting_screen: MarginContainer = $CanvasLayer/SettingScreen



func _ready() -> void:
	if Global.pause_status:
		Global.pause_status = ! Global.pause_status
		toggle_pause_menu()
	else:
		pass

func _input(event) -> void: 
	if event.is_action_pressed("ui_cancel"):  
		toggle_pause_menu()

func toggle_pause_menu():
	menucontainer.visible = ! menucontainer.visible
	main_screen.visible = ! main_screen.visible
	Global.pause_status = !Global.pause_status
	get_tree().paused = Global.pause_status
	

func _on_leave_button_pressed() -> void:
	Global.pause_status = ! Global.pause_status
	get_tree().paused = Global.pause_status
	get_tree().change_scene_to_file("res://scenes/modechoice.tscn")


func _on_setting_pressed() -> void:
	menucontainer.visible = true
	main_screen.visible = false
	Global.pause_status = true
	get_tree().paused = Global.pause_status


func _on_continue_button_pressed() -> void:
	menucontainer.visible = false
	main_screen.visible = true
	Global.pause_status = false
	get_tree().paused = Global.pause_status


func _on_setting_button_pressed() -> void:
	Global.previous_scene_path = get_tree().current_scene.scene_file_path
	Global.pause_status = true
	get_tree().paused = ! Global.pause_status
	setting_screen.visible = true
	menucontainer.visible = false
	main_screen.visible = false
	
	
#======================================= Setting Menu ==============================================

func _on_leave_setting_button_pressed() -> void:
	setting_screen.visible = false
	menucontainer.visible = true
	main_screen.visible = false
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


func _on_option_button_item_selected(index: int) -> void:
	match index:
		0: 
			DisplayServer.window_set_size(Vector2i(1920,1080))
		1:
			DisplayServer.window_set_size(Vector2i(1600,900))
		2: 
			DisplayServer.window_set_size(Vector2i(1280,720))
