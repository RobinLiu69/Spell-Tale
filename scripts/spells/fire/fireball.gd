class_name Fireball
extends Spell

@onready var anim: AnimationPlayer = $AnimationPlayer


var speed: int = 750
var existing_time: float = 6
var velocity = Vector2.RIGHT

func _init() -> void:
	spell_name = "fireball"
	damage = 1
	mana_cost = 1


func _ready():
	await get_tree()
	$ExisitingTimer.set_wait_time(existing_time)
	$ExisitingTimer.start()


func _process(delta):
	position += transform.x * speed * delta



func _on_area_2d_body_entered(body: Node2D) -> void:
	if !is_multiplayer_authority() or body == source:
		return
	
	if body is Player:
		body.take_damage.rpc_id(body.get_multiplayer_authority(), damage, source_path)
	
	remove_self.rpc()

@rpc("call_local")
func remove_self():
	queue_free()


func _on_exisiting_timer_timeout() -> void:
	remove_self.rpc()
