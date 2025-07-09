class_name Setting
extends Control

@onready var setting_stack := $SettingBackground/VBoxContainer
@onready var video_setting := setting_stack.get_node("VideoSetting")
@onready var audio_setting := setting_stack.get_node("AudioSetting")
@onready var control_setting := setting_stack.get_node("ControlSetting")
@onready var button_effect: AudioStreamPlayer2D = $ButtonEffect




func _ready():
	$SettingBackground/VBoxContainer/LeaveAction.action = Callable(self, "_leave_setting")
	$SettingBackground/VBoxContainer/HBoxContainer/HBoxContainer/VideoAction.action = Callable(self, "_go_to_video_setting")
	$SettingBackground/VBoxContainer/HBoxContainer/HBoxContainer/AudioAction.action = Callable(self, "_go_to_audio_setting")
	$SettingBackground/VBoxContainer/HBoxContainer/HBoxContainer/ControlAction.action = Callable(self, "_go_to_control_setting")
	$SettingBackground/SaveAction.action = Callable(self,"_save_setting")
	_show_setting("video") 

func _show_setting(category: String):
	video_setting.visible = (category == "video")
	audio_setting.visible = (category == "audio")
	control_setting.visible = (category == "control")

func _go_to_video_setting() -> void:
	_show_setting("video")


func _go_to_audio_setting() -> void:
	_show_setting("audio")
	

func _go_to_control_setting() -> void:
	_show_setting("control")
		
func _leave_setting() -> void:
	if Global.previous_scene_path == "res://scenes/main.tscn":
		get_tree().change_scene_to_file("res://scenes/main.tscn")
		return
	queue_free()
	
func _save_setting():
	Global.save_config()
	Global.apply_keybindings()
	
