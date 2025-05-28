extends  Node

var SPELLS: Dictionary[String, PackedScene] = {
	"fireball": preload("res://scenes/fireball.tscn"),
	"fire_aura": preload("res://scenes/fire_aura.tscn")
}

func get_spell(name: String) -> PackedScene:
	return SPELLS[name]

func _ready():
	print("SpellRegistry loaded!")
