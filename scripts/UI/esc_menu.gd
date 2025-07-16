extends Control

var player: Player
@onready var setting_scene = preload("res://scenes/ui/setting.tscn")

func _ready() -> void:
	$PanelContainer/VBoxContainer/ContinueAciton.action = Callable(self,"_continue_pressed")
	$PanelContainer/VBoxContainer/SettingAction.action = Callable(self,"_setting_pressed")
	$PanelContainer/VBoxContainer/LeaveAction.action = Callable(self,"_leave_menu")

func _leave_menu() -> void:
	if Global.is_multiplayer_mode:
		owner.exit_game()
	get_tree().change_scene_to_file("res://scenes/ui/modechoice.tscn")
	AudioManager.play_bgm()
	

func _continue_pressed() -> void:
	owner.toggle_pause_menu()
	

func _setting_pressed() -> void:
	print("success setting")
	var setting_screen = setting_scene.instantiate()
	owner.get_node("UI").add_child(setting_screen)
	
