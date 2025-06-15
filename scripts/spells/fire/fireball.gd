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
	$ExisitingTimer.set_wait_time(existing_time)
	$ExisitingTimer.start()


func _process(delta):
	position += transform.x * speed * delta


@rpc("any_peer", "call_local")
func request_remove(spell_id: int):
	SpellManager.request_remove(spell_id)


func hit(hurtbox: HurtboxComponent):
	if hurtbox:
		var attack = Attack.new()
		attack.damage = 5
		hurtbox.damage.rpc(attack.serialize())
	
	rpc("request_remove", spell_id)

func _on_exisiting_timer_timeout() -> void:
	rpc("request_remove", spell_id)
