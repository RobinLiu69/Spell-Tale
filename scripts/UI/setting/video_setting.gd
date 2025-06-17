extends HBoxContainer
class_name VideoSetting

@onready var resolution_option: OptionButton = $Container/ResolutionOption
@onready var screen_mode_option: OptionButton = $Container/ScreenModeOption
@onready var button_effect: AudioStreamPlayer2D = $"../../../ButtonEffect"
@onready var select_effect: AudioStreamPlayer2D = $"../../../SelectEffect"
@onready var framerate_limit_option: OptionButton = $Container/FramerateLimitOption
@onready var v_sync_check: CheckButton = $"Container/V-SyncCheck"
@onready var brightness_slider: HSlider = $Container/BrightnessSlider



func _ready() -> void:
	resolution_option.connect("item_selected", Callable(self, "_on_resolution_option_item_selected"))
	screen_mode_option.connect("item_selected", Callable(self, "_on_screen_mode_item_selected"))
	framerate_limit_option.connect("item_selected",Callable(self,"_on_framerate_option_item_selected"))
	v_sync_check.button_pressed = DisplayServer.window_get_vsync_mode() != DisplayServer.VSYNC_DISABLED
	v_sync_check.connect("toggled", Callable(self, "_on_vsync_check"))
	brightness_slider.value = Global.brightness_value
	brightness_slider.connect("value_changed",Callable(self,"_on_brightness_slider_value_changed"))
	resolution_option.select(Global.resolution_index)
	screen_mode_option.select(Global.screen_mode_index)
	framerate_limit_option.select(Global.framerate_limit_index)
	
	
func _on_resolution_option_pressed() -> void:
	button_effect.play()

func _center_window_posititon() -> void:
	var screen_size = DisplayServer.screen_get_size()
	var window_size = DisplayServer.window_get_size()
	var center_position = (screen_size - window_size) / 2
	DisplayServer.window_set_position(center_position)

func _on_resolution_option_item_selected(index: int) -> void:
	select_effect.play()
	Global.resolution_index = index
	match index:
		0: DisplayServer.window_set_size(Vector2i(1280, 720))
		1: DisplayServer.window_set_size(Vector2i(1600, 900))
		2: DisplayServer.window_set_size(Vector2i(1920,1080))
	_center_window_posititon()

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
	_center_window_posititon()
	
	
	
func _on_vsync_check(pressed: bool) -> void:
	button_effect.play()
	Global.vsync_check_status = pressed
	if pressed:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	

func _on_framerate_option_item_selected(index: int) -> void:
	select_effect.play()
	Global.framerate_limit_index = index  

	match index:
		0:
			Engine.max_fps = 30
		1:
			Engine.max_fps = 60
		2:
			Engine.max_fps = 144
		3:
			Engine.max_fps = 165
		4:
			Engine.max_fps = 240
		5:
			Engine.max_fps = 0
			
			
func _on_brightness_slider_value_changed(value: float) -> void:
	Global.brightness_value = value
	BrightnessManager.set_brightness(1.0 - value)
	
