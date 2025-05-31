extends PanelContainer


var player: Player
@onready var esc_menu: PanelContainer = $"."
@onready var multiplayer_ui: Control = $"../Multiplayer"


func _on_leave_button_pressed() -> void:
	owner.exit_game(player.name)
	get_tree().change_scene_to_file("res://scenes/modechoice.tscn")
	


func _on_continue_button_pressed() -> void:
	toggle_pause_menu()


func toggle_pause_menu():
	esc_menu.visible = ! Global.menu_status
	if Global.multiplayer_ui_status:
		multiplayer_ui.visible = Global.menu_status
	Global.menu_status = ! Global.menu_status
