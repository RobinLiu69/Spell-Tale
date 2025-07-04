extends Node


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


func get_spell_info(spell_id: String) -> Dictionary:
	return spell_data.get(spell_id, {})
	
	
func get_spell_list() -> Array[String]:
	return spell_data.keys()


func instantiate_spell_scene(spell_id: String) -> Node:
	var spell_info = get_spell_info(spell_id)
	var scene_path = spell_info.get("scene", "")
	if scene_path == "":
		push_error("No scene found for spell: %s" % spell_id)
		return null
	var packed_scene := load(scene_path)
	if packed_scene == null:
		push_error("Failed to load scene for spell: %s" % spell_id)
		return null
	return packed_scene.instantiate()
