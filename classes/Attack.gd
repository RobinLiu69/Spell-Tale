class_name Attack

var damage := 0.0
var knockback := 0.0
var crit_chance := 0.0
var effect := {} # {effect_name: [duration, level]}

func serialize() -> Dictionary:
	return {
		"damage": damage,
		"knockback": knockback,
		"crit_chance": crit_chance,
		"effect": effect,
	}

static func deserialize(data: Dictionary) -> Attack:
	var atk = Attack.new()
	atk.damage = data.damage
	atk.knockback = data.knockback
	atk.effect = data.effect
	return atk
