extends Control
@onready var firstcombatbutton: Button = $MainScrren/ScreenTexture/Maincontainer/VBoxContainer/HBoxContainer/Firstcombatbutton
@onready var title_label: Label = $MainScrren/ScreenTexture/Maincontainer/VBoxContainer/CanvasLayer/HBoxContainer/VBoxContainer/achievement1container/VBoxContainer/titlelabel
@onready var description_label: Label = $MainScrren/ScreenTexture/Maincontainer/VBoxContainer/CanvasLayer/HBoxContainer/VBoxContainer/achievement1container/VBoxContainer/descriptionlabel
@onready var unlocked_label: Label = $MainScrren/ScreenTexture/Maincontainer/VBoxContainer/CanvasLayer/HBoxContainer/VBoxContainer/achievement1container/VBoxContainer/unlockedlabel
@onready var achievement_1_container: PanelContainer = $MainScrren/ScreenTexture/Maincontainer/VBoxContainer/CanvasLayer/HBoxContainer/VBoxContainer/achievement1container
@onready var buttonseperator: Button = $MainScrren/ScreenTexture/Maincontainer/VBoxContainer/HBoxContainer/buttonseperator



func _on_leave_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")



func _on_button_pressed() -> void:
	firstcombatbutton.visible = false
	show_achievement(
		"First Combat",
		"You finished your first combat with other",
		true
	)
	buttonseperator.visible = true

func _on_closebutton_pressed() -> void:
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
