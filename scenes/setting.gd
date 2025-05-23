extends Control

@onready var video_setting: VBoxContainer = $mainscreen/SettingBackground/Buttoncontainer/VBoxContainer/VideoSetting
@onready var audio_setting: VBoxContainer = $mainscreen/SettingBackground/Buttoncontainer/VBoxContainer/AudioSetting
@onready var graph_setting: VBoxContainer = $mainscreen/SettingBackground/Buttoncontainer/VBoxContainer/Graphsetting
@onready var misc_setting: VBoxContainer = $mainscreen/SettingBackground/Buttoncontainer/VBoxContainer/MISCsetting


func _on_leave_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
