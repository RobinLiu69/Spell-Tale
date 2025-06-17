extends Node

#unknown (probably can be deleted)
var previous_scene_path: String = ""
var pause_status: bool = false

#achievement
var achivement1_status: bool = false

#multiplayer
var is_multiplayer_mode: bool = true
var menu_status: bool = false
var multiplayer_ui_status: bool = true
var multiplayer_IP: String = "" 
var server_port: int = 1

#setting-audio
var master_volume: float = 0.5

#setting-video
var resolution_index: int = 2
var screen_mode_index: int = 0	
var framerate_limit_index: int = 5
var vsync_check_status: bool = true
var brightness_value: float = 0.0 


func _ready():
	AudioServer.set_bus_volume_db(0, linear_to_db(master_volume))
