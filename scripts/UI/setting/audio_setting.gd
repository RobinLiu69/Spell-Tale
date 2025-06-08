extends HBoxContainer
class_name AudioSetting

@onready var master_volume_slider: Slider = $Container/MasterVolumeBar

func _ready() -> void:
	master_volume_slider.connect("value_changed", Callable(self, "_on_volumesetting_value_changed"))
	

func _on_volumesetting_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, value)
	print(value)
