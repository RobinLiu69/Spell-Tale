class_name Spell
extends Node2D

var spell_name: String = "Unnamed Spell"
var spell_id: int = 1
var source: Player = null
var source_path: String = ""
var damage: float = 0
var mana_cost: float = 0
var caster_pid: int = 0
func cast():
	pass

func hit(hurtbox: HurtboxComponent):
	pass
