extends Control

@onready var filter: ColorRect = $BrightnessFilter

func _ready():
	set_brightness(Global.brightness_value)  

func set_brightness(value: float) -> void:
	var alpha = clamp(1.0 - value, 0.0, 1.0)  
	filter.color = Color(0, 0, 0, alpha)
	print("Set brightness to:", alpha)
