class_name Attack

var damage := 0
var knockback := 0.0
var crit_chance := 0.0
var element := "neutral"

func serialize() -> Dictionary:
	return {
		"damage": damage,
		"knockback": knockback,
		"crit_chance": crit_chance,
		"element": element,
	}

static func deserialize(data: Dictionary) -> Attack:
	var atk = Attack.new()
	atk.damage = data.damage
	atk.knockback = data.knockback
	atk.crit_chance = data.crit_chance
	atk.element = data.element
	return atk
