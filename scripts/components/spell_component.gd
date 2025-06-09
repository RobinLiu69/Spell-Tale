class_name SpellComponent
# SpellComponent.gd
extends Node

var source: Node2D
var spellcon: Node2D
var marker: Marker2D

var spell_1 := "fireball"
var spell_2 := "void_snare"
var spell_3 := "fire_aura"


func set_source(src: Node2D):
	source = src
	spellcon = source.get_node("SpellCon")
	marker = source.get_node("SpellCon/Marker2D")

func update_spellcon(pos: Vector2):
	spellcon.look_at(pos)

func cast_spell(slot: int, target_pos: Vector2):
	var spell_name: String
	match slot:
		1: spell_name = spell_1
		2: spell_name = spell_2
		3: spell_name = spell_3
		_: return
	_cast_rpc.rpc(multiplayer.get_unique_id(), spell_name, target_pos)

@rpc("call_local")
func _cast_rpc(caster_pid: int, spell_name: String, target_pos: Vector2):
	if not SpellRegistry.SPELLS.has(spell_name):
		push_error("spell %s not found in registry" % spell_name)
		return
	var spell_info := SpellRegistry.get_spell_info(spell_name)
	var cast_at: String = spell_info[0]
	var spell: Spell = spell_info[-1].instantiate()
	spell.source = source
	spell.source_path = source.get_path()
	spell.set_multiplayer_authority(caster_pid)
	source.get_parent().add_child(spell)

	match cast_at:
		"marker":
			spell.position = marker.global_position
			spell.rotation = marker.global_rotation
		"target_pos":
			spell.position = target_pos
		"self":
			pass
	spell.cast()
