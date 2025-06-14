extends HBoxContainer
class_name VideoSetting

@onready var resolution_option: OptionButton = $Container/ResolutionOption
@onready var screen_mode_option: OptionButton = $Container/ScreenModeOption
@onready var button_effect: AudioStreamPlayer2D = $"../../../ButtonEffect"
@onready var select_effect: AudioStreamPlayer2D = $"../../../SelectEffect"



func _ready() -> void:
	resolution_option.connect("item_selected", Callable(self, "_on_resolution_option_item_selected"))
	screen_mode_option.connect("item_selected", Callable(self, "_on_screen_mode_item_selected"))
	resolution_option.select(Global.resolution_index)
	screen_mode_option.select(Global.screen_mode_index)
	
func _on_resolution_option_pressed() -> void:
	button_effect.play()

func _on_resolution_option_item_selected(index: int) -> void:
	select_effect.play()
	Global.resolution_index = index
	match index:
		0: DisplayServer.window_set_size(Vector2i(1280, 720))
		1: DisplayServer.window_set_size(Vector2i(1600, 900))
		2: DisplayServer.window_set_size(Vector2i(1920,1080))


func _get_resolution_by_index(index: int) -> Vector2i:
	match index:
		0: return Vector2i(1280, 720)
		1: return Vector2i(1600, 900)
		2: return Vector2i(1920, 1080)
		_: return Vector2i(1920, 1080)

func _on_screen_mode_item_selected(index: int) -> void:
	select_effect.play()
	Global.screen_mode_index = index
	var size = _get_resolution_by_index(resolution_option.get_selected_id())

	match index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			DisplayServer.window_set_size(size)
		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
			DisplayServer.window_set_size(size)
		3:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
