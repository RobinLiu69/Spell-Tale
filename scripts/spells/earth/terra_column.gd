class_name TerraColumn
extends Spell

@export var lift_time := 1.0
@onready var anim := $AnimationPlayer

var hitbox_enabled := false

func _ready():
	damage = 2
	anim.play("raise")
	await anim.animation_finished

func hit(hurtbox):
	var attack = Attack.new()
	attack.damage = damage
	hurtbox.damage.rpc(attack.serialize())

	
