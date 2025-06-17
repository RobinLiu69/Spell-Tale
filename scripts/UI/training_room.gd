extends Node2D

#@onready var menucontainer: MarginContainer = $CanvasLayer/Menucontainer 路徑找不到節點且沒用到導致報錯 先註解(Berry)
@onready var main_screen: MarginContainer = $MainScreen
@export var setting_scene: PackedScene
var game: Node2D

func _ready() -> void:
	game = get_node("MainScreen/Buttoncontainer/Game")
	Global.previous_scene_path = "res://scenes/games/training_room.tscn"
	if Global.pause_status:
		Global.pause_status = ! Global.pause_status
		game.toggle_pause_menu()
	else:
		pass

func _input(event) -> void: 
	if event.is_action_pressed("ui_cancel") && get_tree().current_scene.name == "TrainingRoom":  
		game.toggle_pause_menu()


	
