extends Node2D

@onready var main_menu: Control = $MarginContainer/MainMenu


func _ready() -> void:
	main_menu.visible = true
