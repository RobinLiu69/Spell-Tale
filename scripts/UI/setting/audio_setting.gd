extends HBoxContainer
class_name AudioSetting

@onready var master_volume: Label = $Container/MasterVolume
@onready var master_volume_slider: Slider = $Container/MasterVolumeBar
@onready var music_volume: Label = $Container/MusicVolume
@onready var music_volume_bar: HSlider = $Container/MusicVolumeBar
@onready var effect_volume: Label = $Container/EffectVolume
@onready var effect_volume_bar: HSlider = $Container/EffectVolumeBar


func _ready() -> void:
	master_volume_slider.value = Global.master_volume
	music_volume_bar.value = Global.music_volume
	effect_volume_bar.value = Global.effect_volume


	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(Global.master_volume))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(Global.music_volume))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Effect"), linear_to_db(Global.effect_volume))

	
	master_volume_slider.connect("value_changed", Callable(self, "_on_master_volume_changed"))
	music_volume_bar.connect("value_changed", Callable(self, "_on_music_volume_changed"))
	effect_volume_bar.connect("value_changed", Callable(self, "_on_effect_volume_changed"))

	update_volume_display()

func _on_master_volume_changed(value: float) -> void:
	Global.master_volume = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))
	AudioManager.play_click_sound()
	update_volume_display()
	
func _on_music_volume_changed(value: float) -> void:
	Global.music_volume = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value))
	update_volume_display()

func _on_effect_volume_changed(value: float) -> void:
	Global.effect_volume = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Effect"), linear_to_db(value))
	AudioManager.play_click_sound()
	update_volume_display()
	
func update_volume_display() -> void:
	master_volume.text = "Master Volume: " + str(int(Global.master_volume * 100)) + "%"
	music_volume.text = "Music Volume: " + str(int(Global.music_volume * 100)) + "%"
	effect_volume.text = "Effect Volume: " + str(int(Global.effect_volume * 100)) + "%"
	
	
	
	
	
