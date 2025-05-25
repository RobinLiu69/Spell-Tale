extends Control


func _on_play_button_pressed() -> void:
	print("playbutton pressed")
	get_tree().change_scene_to_file("res://scenes/main.tscn")
	
func _on_setting_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/setting.tscn")
	
func _on_store_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/store.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()
