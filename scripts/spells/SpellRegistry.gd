extends Node

var SPELLS: Dictionary = {}

var spell_data: Dictionary = {}

func _ready():
	var file := FileAccess.open("res://data/spells.json", FileAccess.READ)
	if file:
		var content := file.get_as_text()
		spell_data = JSON.parse_string(content)
		file.close()
		print("SpellRegistry loaded with %d spells." % spell_data.size())
	else:
		push_error("Failed to load res://data/spells.json")
		
	for spell_name in spell_data.keys():
		var spell_info: Dictionary = spell_data[spell_name]
		var spell_path: String = spell_info.get("scene", "")
		if spell_path == "":
			push_error("Missing 'scene' for spell: %s" % spell_name)
			continue

		var packed_scene = load(spell_path)
		if not packed_scene:
			push_error("Failed to load scene: %s" % spell_path)
			continue

		SPELLS[spell_name] = spell_info

		SPELLS[spell_name]["packed_scene"] = packed_scene


func get_spell_info(spell_name: String) -> Dictionary:
	return SPELLS.get(spell_name, {})
	
	
func get_spell_list() -> Array[String]:
	return SPELLS.keys()
