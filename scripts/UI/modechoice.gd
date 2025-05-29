extends Control




func _on_leave_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")




func _on_training_modebutton_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/training_room.tscn")


func _on_battle_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")
