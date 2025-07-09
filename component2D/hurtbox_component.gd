class_name HurtboxComponent
extends Component2D

@export var entity: CharacterBody2D
@export var hurtbox: Area2D

func _ready() -> void:
	hurtbox

@rpc("any_peer", "call_local")
func damage(_attack: Dictionary):
	var attack: Attack = Attack.deserialize(_attack)
	#print(Attack.deserialize(attack).damage)

	if entity:
		entity.got_hit(attack)
	
func take_damage(attack: Dictionary):
	emit_signal("got_hit", Attack.deserialize(attack))
