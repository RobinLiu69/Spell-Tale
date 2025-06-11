extends Node

@export var button_path: NodePath
@export var action: Callable
@export var button_effect: AudioStreamPlayer2D


func _ready():
	var button = get_node(button_path)
	if button and button is Button:
		button.pressed.connect(_on_button_pressed)

func _on_button_pressed():
	button_effect.play()
	if action and action.is_valid():
		action.call()
