class_name VoidSnare
extends Spell

@onready var anim: AnimationPlayer = $AnimationPlayer

func _init() -> void:
	damage = 3

func _ready():
	self.global_position = get_global_mouse_position()
	if anim:
		anim.play("fire")


@rpc("call_local")
func remove_self():
	queue_free()

func hit(hurtbox: HurtboxComponent) -> void:
	print("hit")
	if hurtbox:
		var attack = Attack.new()
		attack.damage = damage
		hurtbox.damage.rpc(attack.serialize())

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	remove_self()
