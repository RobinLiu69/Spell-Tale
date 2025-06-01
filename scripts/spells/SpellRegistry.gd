extends  Node

var SPELLS: Dictionary[String, Array] = {
	"fireball": ["marker", preload("res://scenes/spells/fire/fireball.tscn")],
	"fire_aura": ["self", preload("res://scenes/spells/fire/fire_aura.tscn")],
	"void_snare": ["target_pos", preload("res://scenes/spells/void/void_snare.tscn")],
	"void_laser": ["marker", preload("res://scenes/spells/void/void_laser.tscn")]
}

func get_spell_info(name: String) -> Array:
	return SPELLS[name]

func _ready():
	print("SpellRegistry loaded!")
