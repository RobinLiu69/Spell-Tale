class_name Spell
extends Node2D

var spell_name: String = "Unnamed Spell"
var spell_id: int = -1
var source: Player = null
var source_path: String = ""
var damage: float = 0
var mana_cost: float = 0
var caster_pid: int = 0

func _ready():
	if spell_id == -1:
		push_error("Incorrect spell_id")

	if is_multiplayer_authority():
		SpellManager.register_spell(spell_id, self)


func cast() -> bool:
	return true

func hit(hurtbox: HurtboxComponent):
	pass

func hit_body(body: Node2D):
	pass

func request_remove():
	if is_multiplayer_authority():
		rpc("_request_remove", spell_id)

@rpc("any_peer", "call_local")
func _request_remove(_spell_id: int):
	SpellManager.request_remove(_spell_id)
