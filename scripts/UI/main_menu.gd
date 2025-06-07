extends Control


func _ready():
	$HomePage/HomePageBackground/VBoxContainer/HBoxContainer/VBoxContainer/PlayAction.action = Callable(self, "_go_to_modechoice")
	$HomePage/HomePageBackground/VBoxContainer/HBoxContainer/VBoxContainer/SettingAction.action = Callable(self, "_go_to_setting")
	$HomePage/HomePageBackground/VBoxContainer/HBoxContainer/VBoxContainer/StoreAction.action = Callable(self, "_go_to_store")
	$HomePage/HomePageBackground/VBoxContainer/HBoxContainer/VBoxContainer/QuitAction.action = Callable(self, "_quit_game")

func _go_to_modechoice():
	get_tree().change_scene_to_file("res://scenes/modechoice.tscn")

func _go_to_setting():
	Global.previous_scene_path = get_tree().current_scene.scene_file_path
	get_tree().change_scene_to_file("res://scenes/setting.tscn")

func _go_to_store():
	get_tree().change_scene_to_file("res://scenes/achievement.tscn")

func _quit_game():
	get_tree().quit()
