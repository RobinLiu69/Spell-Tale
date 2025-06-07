extends  Node

const TOTEMS: Dictionary[String, PackedScene] = {
	"fire_totem": preload("res://scenes/spells/void/void_laser.tscn")
}

func get_totem_info(name: String) -> PackedScene:
	return TOTEMS[name]

func _ready():
	print("TotemRegistry loaded!")
