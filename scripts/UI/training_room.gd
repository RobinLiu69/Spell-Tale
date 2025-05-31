extends Node2D

@onready var menucontainer: MarginContainer = $CanvasLayer/Menucontainer
@onready var main_screen: MarginContainer = $MainScreen
@export var setting_scene: PackedScene


func _ready() -> void:
	if Global.pause_status:
		Global.pause_status = ! Global.pause_status
		toggle_pause_menu()
	else:
		pass

func _input(event) -> void: 
	if event.is_action_pressed("ui_cancel") && get_tree().current_scene.name == "TrainingRoom":  
		toggle_pause_menu()

func toggle_pause_menu():
	menucontainer.visible = ! menucontainer.visible
	main_screen.visible = ! main_screen.visible
	Global.pause_status = !Global.pause_status
	get_tree().paused = Global.pause_status
	

func _on_leave_button_pressed() -> void:
	Global.pause_status = ! Global.pause_status
	get_tree().paused = Global.pause_status
	get_tree().change_scene_to_file("res://scenes/modechoice.tscn")



func _on_continue_button_pressed() -> void:
	menucontainer.visible = false
	main_screen.visible = true
	Global.pause_status = false
	get_tree().paused = Global.pause_status


func _on_setting_button_pressed() -> void:
	if $CanvasLayer.has_node("Setting"):
		return
	var setting = setting_scene.instantiate()
	$CanvasLayer.add_child(setting)
	Global.pause_status = true
	get_tree().paused = ! Global.pause_status
	
