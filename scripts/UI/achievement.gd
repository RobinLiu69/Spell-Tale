extends Control
@onready var firstcombatbutton: Button = $MainScrren/ScreenTexture/Maincontainer/VBoxContainer/HBoxContainer/Firstcombatbutton
@onready var title_label: Label = $MainScrren/ScreenTexture/Maincontainer/VBoxContainer/CanvasLayer/HBoxContainer/VBoxContainer/achievement1container/VBoxContainer/titlelabel
@onready var description_label: Label = $MainScrren/ScreenTexture/Maincontainer/VBoxContainer/CanvasLayer/HBoxContainer/VBoxContainer/achievement1container/VBoxContainer/descriptionlabel
@onready var unlocked_label: Label = $MainScrren/ScreenTexture/Maincontainer/VBoxContainer/CanvasLayer/HBoxContainer/VBoxContainer/achievement1container/VBoxContainer/unlockedlabel
@onready var achievement_1_container: PanelContainer = $MainScrren/ScreenTexture/Maincontainer/VBoxContainer/CanvasLayer/HBoxContainer/VBoxContainer/achievement1container
@onready var buttonseperator: Button = $MainScrren/ScreenTexture/Maincontainer/VBoxContainer/HBoxContainer/buttonseperator

func _ready() -> void:
	$MainScrren/ScreenTexture/Maincontainer/VBoxContainer/LeaveAction.action = Callable(self, "_leave_achievement")
	$MainScrren/ScreenTexture/Maincontainer/VBoxContainer/HBoxContainer/FirstcombatAction.action = Callable(self, "_first_combat_button_pressed")
	$MainScrren/ScreenTexture/Maincontainer/VBoxContainer/CanvasLayer/HBoxContainer/VBoxContainer/achievement1container/closeaction.action = Callable(self, "_close_button_pressed")



func _leave_achievement() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")



func _first_combat_button_pressed() -> void:
	firstcombatbutton.visible = false
	show_achievement(
		"First Combat",
		"You finished your first combat with other",
		Global.achivement1_status
	)
	buttonseperator.visible = true

func _close_button_pressed() -> void:
	achievement_1_container.visible = false
	firstcombatbutton.visible = true
	buttonseperator.visible = false

func show_achievement(title: String, description: String, unlocked: bool):
	title_label.text = title
	description_label.text = description
	if unlocked:
		unlocked_label.text = "[achievement unlocked]"
	else:
		unlocked_label.text = "[achievement locked]"
	achievement_1_container.visible = true
