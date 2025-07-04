extends Component
class_name CooldownComponent

var cooldowns: Dictionary = {}

var global_cooldown: float = 0.0

func update_component(delta: float) -> void:
	if global_cooldown > 0:
		global_cooldown = max(0, global_cooldown - delta)

	for key in cooldowns.keys():
		cooldowns[key] = max(0, cooldowns[key] - delta)

func set_cooldown(spell_name: String, duration: float) -> void:
	cooldowns[spell_name] = duration

func set_global_cooldown(duration: float) -> void:
	global_cooldown = duration

func is_on_cooldown(spell_name: String) -> bool:
	if global_cooldown > 0:
		return true
	if cooldowns.has(spell_name) and cooldowns[spell_name] > 0:
		return true
	return false
