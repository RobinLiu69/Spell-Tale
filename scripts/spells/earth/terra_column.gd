class_name TerraColumn
extends Spell

@export var lift_time := 1.0
@onready var anim := $AnimationPlayer

var hitbox_enabled := false

func _ready():
	damage = 2
	anim.play("raise")
	await anim.animation_finished
	hitbox_enabled = true

func hit(hurtbox):
	var attack = Attack.new()
	attack.damage = damage
	hurtbox.damage.rpc(attack.serialize())

	
	hurtbox.entity.effect_manager_component.request_add_effect("airborne_effect", 1.5, 4)
