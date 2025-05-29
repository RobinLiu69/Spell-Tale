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

func _on_body_entered(body: Node2D) -> void:
	if !is_multiplayer_authority() or body == source:
		return
	
	if body is Player:
		body.take_damage.rpc_id(body.get_multiplayer_authority(), damage, source_path)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	remove_self()
