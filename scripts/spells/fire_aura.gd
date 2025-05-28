class_name FireAura
extends Spell

@onready var anim: AnimationPlayer = $AnimationPlayer


var existing_time: float = 6
var velocity = Vector2.RIGHT

func _init() -> void:
	spell_name = "fire_aura"
	damage = 1
	mana_cost = 1


func _ready():
	await get_tree()
	anim.play("fire_aura_playing")
	$ExisitingTimer.set_wait_time(existing_time)
	$ExisitingTimer.start()


func _process(delta):
	position = source.position


func _on_fireball_body_entered(body: Node2D) -> void:
	if !is_multiplayer_authority():
		return
	
	if body is Player:
		body.take_damage.rpc_id(body.get_multiplayer_authority(), damage, source)
	

@rpc("call_local")
func remove_self():
	queue_free()


func _on_exisiting_timer_timeout() -> void:
	remove_self.rpc()
