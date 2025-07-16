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
	var pid = hurtbox.get_multiplayer_authority()
	var attack = Attack.new()
	attack.damage = damage
	hurtbox.damage.rpc(attack.serialize())
	
	print("atk")
	#hurtbox.owner.position.y -= 300
	EffectManager.request_add_effect(pid, "airborne", 0.5, 1)
