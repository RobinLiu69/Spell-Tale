extends Node


func _ready() -> void:
	$MarginContainer/MainUITexture/MarginContainer/VBoxContainer/LeaveAction.action = Callable(self,"_on_leave_pressed")
	$MarginContainer/MainUITexture/MarginContainer/VBoxContainer/modebuttonscontainer/BattleAction.action = Callable(self, "_go_to_online_battle")
	$MarginContainer/MainUITexture/MarginContainer/VBoxContainer/modebuttonscontainer/TrainingAction.action = Callable(self, "_go_to_training_room")
func _on_leave_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _go_to_online_battle() -> void:
	Global.is_multiplayer_mode = true
	get_tree().change_scene_to_file("res://scenes/ui/spellchoice.tscn")


func _go_to_training_room() -> void:
	Global.is_multiplayer_mode = false
	get_tree().change_scene_to_file("res://scenes/ui/spellchoice.tscn")
