extends Control




func _on_leave_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_battle_button_pressed() -> void:
	Global.is_multiplayer_mode = true
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_training_modebutton_pressed() -> void:
	Global.is_multiplayer_mode = false
	get_tree().change_scene_to_file("res://scenes/training_room.tscn")
