extends Control
class_name Multiplayer


@onready var topic: Label = $UI/MarginContainer/VBoxContainer/HBoxContainer/JoinUI/VBoxContainer/Topic
@onready var result: Label = $UI/MarginContainer/VBoxContainer/HBoxContainer/JoinUI/VBoxContainer/Result
@onready var margin_container: MarginContainer = $UI/MarginContainer
@onready var join_friend_button: Button = $MainScreen/BackgroundTexture/VBoxContainer/HBoxContainer/JoinFriendButton
@onready var seperate_button: Button = $MainScreen/BackgroundTexture/VBoxContainer/HBoxContainer/SeperateButton
@onready var result_host: Label = $MainScreen/BackgroundTexture/VBoxContainer/ResultHost

var game_scene_ref

func _on_host_button_pressed() -> void:
	if game_scene_ref:
		game_scene_ref.host_room()
		game_scene_ref.port_manifest()
		print(Global.server_port)
		queue_free()
	else:
		print("failed")
	
	

func _on_join_friend_button_pressed() -> void:
	margin_container.visible = true
	join_friend_button.visible = false
	seperate_button.visible = true
	
	

func _on_leavebutton_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/modechoice.tscn")
	Global.is_multiplayer_mode = ! Global.is_multiplayer_mode
	print(Global.is_multiplayer_mode)
	
	
func _on_submit_button_pressed() -> void:
	var user_input : PackedStringArray = $UI/MarginContainer/VBoxContainer/HBoxContainer/JoinUI/VBoxContainer/IPInput.text.split(":")
	if user_input.size() > 1:
		Global.multiplayer_IP = user_input[0]
	Global.server_port = int(user_input[-1])	
	if Global.multiplayer_IP == null:
		result.text = "Invalid IP, can't join the room!"
		result.visible = true
		topic.visible = false
		await get_tree().create_timer(5.0).timeout
		result.visible = true
		topic.visible = false
	elif Global.server_port == null:
		result.text = "Invalid Port, can't join the room!"
		result.visible = true
		topic.visible = false
		await get_tree().create_timer(5.0).timeout
		result.visible = true
		topic.visible = false
	elif game_scene_ref:
		game_scene_ref.join_room()
		queue_free()
		
	
func _on_cancel_button_pressed() -> void:
	margin_container.visible = false
	join_friend_button.visible = true
	seperate_button.visible = false
