extends Node


class_name ButtonAction

@export var button_path: NodePath
@export var action: Callable


func _ready():
	var button = get_node(button_path)
	if button and button is Button:
		button.pressed.connect(_on_button_pressed)

func _on_button_pressed():
	if action and action.is_valid():
		action.call()
