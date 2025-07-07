class_name HealthBar
extends ProgressBar

@onready var timer := $Timer
@onready var damage_bar := $DamageBar
@onready var health_label := $HealthLabel

var max_health := 10.0
var health := 10.0 : set = _set_health

func _set_health(new_health):
	var prev_health = health
	health = clamp(new_health, 0, max_health)
	value = health
	_update_label()

	if health < prev_health:
		timer.start()
	else:
		damage_bar.value = health

func init_health(_health: float):
	max_health = _health
	health = _health
	max_value = max_health
	value = health
	damage_bar.max_value = max_health
	damage_bar.value = health
	_update_label()

func _on_timer_timeout() -> void:
	damage_bar.value = health
	
func _update_label():  
	health_label.text = "%d / %d" % [health, max_health]
