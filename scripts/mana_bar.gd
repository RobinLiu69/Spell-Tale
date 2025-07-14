class_name ManaBar
extends ProgressBar

@onready var mana_label: Label = $ManaLabel
@onready var delay_bar := $DelayBar
@onready var timer := $Timer

var max_mana := 10.0
var current_mana := 0.0 : set = _set_mana

func _set_mana(new_mana: float):
	var prev = current_mana
	current_mana = clamp(new_mana, 0, max_mana)
	value = current_mana
	_update_label()
	
	
	if current_mana < prev:
		timer.start()
	else:
		delay_bar.value = current_mana

func init_mana(max_val: float):
	max_value = max_val
	value = current_mana
	delay_bar.max_value = max_val
	delay_bar.value = current_mana
	_update_label()

func set_mana(value: float) -> void:
	_set_mana(value)

func _on_timer_timeout():
	delay_bar.value = current_mana

func _update_label():
	mana_label.text = "%d / %d" % [current_mana, max_mana]

func set_bar_color(color: Color) -> void:
	modulate = color
	delay_bar.modulate = color.darkened(0.3)
