extends HBoxContainer
class_name AudioSetting
@onready var master_volume: Label = $Container/MasterVolume
@onready var master_volume_slider: Slider = $Container/MasterVolumeBar

func _ready() -> void:
	master_volume_slider.value = Global.master_volume
	AudioServer.set_bus_volume_db(0, linear_to_db(Global.master_volume))
	master_volume_slider.connect("value_changed", Callable(self, "_on_volumesetting_value_changed"))
	master_volume.text = "Master Volume: "+ str(round(Global.master_volume*100)) + "%"

func _on_volumesetting_value_changed(value: float) -> void:
	Global.master_volume = value
	AudioServer.set_bus_volume_db(0, linear_to_db(value))
	AudioManager.click_sound.play()
	update_volume_display(value)
	
func update_volume_display(value: float) -> void:
	var percent := int(value * 100.0)
	master_volume.text = "Master Volume: "+ str(percent) + "%"
