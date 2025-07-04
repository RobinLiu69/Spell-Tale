extends Node

const SPELLS: Dictionary[String, Array] = {
	"fireball": ["marker", {
		"mana_cost": {"fire": 1}, 
		"cooldown": 1.0
	}, preload("res://scenes/spells/fire/fireball.tscn")],
	"fire_aura": ["self", {
		"mana_cost": {"fire": 1},
		"cooldown": 5.0
	}, preload("res://scenes/spells/fire/fire_aura.tscn")],
	"void_snare": ["target_pos", {
		"mana_cost": {"dark": 1},
		"cooldown": 1.5
	}, preload("res://scenes/spells/void/void_snare.tscn")],
	"void_laser": ["marker", {
		"mana_cost": {"dark": 0},
		"cooldown": 1
	}, preload("res://scenes/spells/void/void_laser.tscn")]
}

func get_spell_info(name: String) -> Array:
	return SPELLS[name]

func _ready():
	print("SpellRegistry loaded!")
