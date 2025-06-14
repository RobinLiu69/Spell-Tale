extends Node

var previous_scene_path: String = ""
var pause_status: bool = false
var achivement1_status: bool = false
var is_multiplayer_mode: bool = true
var menu_status: bool = false
var multiplayer_ui_status: bool = true
var multiplayer_IP: String = "" 
var server_port: int = 1
var master_volume: float = 0.5
var resolution_index: int = 2
var screen_mode_index: int = 0	

func _ready():
	AudioServer.set_bus_volume_db(0, linear_to_db(master_volume))
