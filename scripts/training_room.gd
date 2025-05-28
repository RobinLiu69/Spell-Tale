extends Node2D

@onready var menucontainer: MarginContainer = $CanvasLayer/Menucontainer
@onready var main_screen: MarginContainer = $MainScreen

func _ready() -> void:
	if Global.pause_status:
		toggle_pause_menu()
	else:
		pass

func _input(event) -> void: 
	if event.is_action_pressed("ui_cancel"):  
		toggle_pause_menu()

func toggle_pause_menu():
	menucontainer.visible = !menucontainer.visible
	main_screen.visible = ! main_screen.visible
	Global.pause_status = !Global.pause_status
	


func _on_leave_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/modechoice.tscn")

func _on_setting_pressed() -> void:
	menucontainer.visible = true
	main_screen.visible = false
	Global.pause_status = true


func _on_continue_button_pressed() -> void:
	menucontainer.visible = false
	main_screen.visible = true
	Global.pause_status = false


func _on_setting_button_pressed() -> void:
	Global.previous_scene_path = get_tree().current_scene.scene_file_path
	get_tree().change_scene_to_file("res://scenes/setting.tscn")
	
	

	
