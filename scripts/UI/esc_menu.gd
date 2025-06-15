extends Control

var player: Player
@onready var setting_scene = preload("res://scenes/ui/setting.tscn")
@onready var port_display_in_game: MarginContainer = $"../PortDisplayInGame"


func _ready() -> void:
	$ESCMenu/VBoxContainer/ContinueAction.action = Callable(self,"_continue_pressed")
	$ESCMenu/VBoxContainer/SettingAction.action = Callable(self,"_setting_pressed")
	$ESCMenu/VBoxContainer/LeaveAction.action = Callable(self,"_leave_menu")


func _leave_menu() -> void:
	if Global.is_multiplayer_mode:
		owner.exit_game(player.name)
	get_tree().change_scene_to_file("res://scenes/ui/modechoice.tscn")
	

func _continue_pressed() -> void:
	owner.toggle_pause_menu()
	

func _setting_pressed() -> void:
	var setting_screen = setting_scene.instantiate()
	owner.get_node("UI").add_child(setting_screen)
	
