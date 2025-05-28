extends Control


func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/modechoice.tscn")
	
func _on_setting_button_pressed() -> void:
	Global.previous_scene_path = get_tree().current_scene.scene_file_path
	get_tree().change_scene_to_file("res://scenes/setting.tscn")
	
func _on_store_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/achievement.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()
