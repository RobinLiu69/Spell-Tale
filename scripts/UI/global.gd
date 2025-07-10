extends Node

#unknown (probably can be deleted)
var previous_scene_path: String = ""
var pause_status: bool = false

#key binds
const BINDABLE_ACTIONS = ["left", "right", "jump", "special_1","special_2","special_3","pause"]

var keybindings := {
	"left": "A",
	"right": "D",
	"jump": "Space",
	"special_1": "Q", 
	"special_2": "W",
	"special_3": "E",
	"pause": "Escape"
}

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
var music_volume: float = 0.5
var effect_volume: float = 0.5

#setting-video
var resolution_index: int = 2
var screen_mode_index: int = 0	
var framerate_limit_index: int = 5
var vsync_check_status: bool = true
var brightness_value: float = 0.0 


#spell
var spell_1: String = "fire_aura"
var spell_2: String = "terra_column_spell"
var spell_3: String = "water_orb_spell"


#mana
var player_mana_component: ManaComponent = null
var enemy_mana_component: ManaComponent = null

#element
var selected_element: String = "fire"
var enemy_element: String = "fire"

#character
var selected_character: String = ""

#player score
var player_1_score:int = 0
var player_2_score:int = 0

#pid
var revealed_spell_ids:Array[String] = []

#misc
var fullscreen_status = false

func _ready():
	#load_config()
	apply_keybindings()
	AudioServer.set_bus_volume_db(0, linear_to_db(master_volume))
	
func save_config():
	var config = {

		"master_volume": master_volume,
		"music_volume": music_volume,
		"effect_volume": effect_volume,

		"resolution_index": resolution_index,
		"screen_mode_index": screen_mode_index,
		"framerate_limit_index": framerate_limit_index,
		"vsync_check_status": vsync_check_status,
		"brightness_value": brightness_value,

		"keybindings": keybindings,

		"spell_1": spell_1,
		"spell_2": spell_2,
		"spell_3": spell_3,

		"selected_character": selected_character,

		"selected_element": selected_element,
		"enemy_element": enemy_element,

		"fullscreen_status": fullscreen_status
	}

	var file = FileAccess.open("user://config.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(config, "\t"))
	file.close()
	
func load_config():
	if not FileAccess.file_exists("user://config.json"):
		return
	
	var file = FileAccess.open("user://config.json", FileAccess.READ)

	var content = file.get_as_text()
	file.close()

	var data = JSON.parse_string(content)
	if typeof(data) != TYPE_DICTIONARY:
		print("Config file is not a dictionary")
		return

	master_volume = data.get("master_volume", master_volume)
	music_volume = data.get("music_volume", music_volume)
	effect_volume = data.get("effect_volume", effect_volume)

	resolution_index = data.get("resolution_index", resolution_index)
	screen_mode_index = data.get("screen_mode_index", screen_mode_index)
	framerate_limit_index = data.get("framerate_limit_index", framerate_limit_index)
	vsync_check_status = data.get("vsync_check_status", vsync_check_status)
	brightness_value = data.get("brightness_value", brightness_value)

	keybindings = data.get("keybindings", keybindings)

	spell_1 = data.get("spell_1", spell_1)
	spell_2 = data.get("spell_2", spell_2)
	spell_3 = data.get("spell_3", spell_3)

	selected_character = data.get("selected_character", selected_character)

	selected_element = data.get("selected_element", selected_element)
	enemy_element = data.get("enemy_element", enemy_element)

	fullscreen_status = data.get("fullscreen_status", fullscreen_status)
	
func apply_keybindings():
	for action in BINDABLE_ACTIONS:
			InputMap.action_erase_events(action)

	for action in keybindings:
		var ev = InputEventKey.new()
		ev.keycode = OS.find_keycode_from_string(keybindings[action])
		InputMap.action_add_event(action, ev)
