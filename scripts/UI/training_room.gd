
class_name TrainingRoom
extends Node2D

@onready var esc_menu: Control = $UI/EscMenu
@onready var main_screen: MarginContainer = $MainScreen
@export var setting_scene: PackedScene
var game: Game

func _ready() -> void:
	Global.previous_scene_path = "res://scenes/games/training_room.tscn"
	game = get_node("MainScreen/GameContainer/Game")

func _input(event) -> void: 
	if event.is_action_pressed("ui_cancel") && get_tree().current_scene.name == "TrainingRoom":  
		game.toggle_pause_menu()


	

	


	
