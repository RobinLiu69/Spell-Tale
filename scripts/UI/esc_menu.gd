extends PanelContainer


var player: Player
@onready var esc_menu: PanelContainer = $"."
@onready var setting_scene = preload("res://scenes/setting.tscn")
@onready var port_display_in_game: MarginContainer = $"../PortDisplayInGame"



func _on_leave_button_pressed() -> void:
	owner.exit_game(player.name)
	get_tree().change_scene_to_file("res://scenes/modechoice.tscn")
	

func _on_continue_button_pressed() -> void:
	toggle_pause_menu()
	

func _on_setting_button_pressed() -> void:
	var setting_screen = setting_scene.instantiate()
	owner.get_node("UI").add_child(setting_screen)
	


func toggle_pause_menu():
	esc_menu.visible = ! Global.menu_status
	port_display_in_game.visible = ! Global.menu_status
	Global.menu_status = ! Global.menu_status
