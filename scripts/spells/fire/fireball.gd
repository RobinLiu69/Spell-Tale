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

func hit(hurtbox: HurtboxComponent):
	var attack = Attack.new()
	attack.damage = damage
	hurtbox.damage.rpc(attack.serialize())
	request_remove()

func hit_body(body):
	request_remove()

func _on_exisiting_timer_timeout() -> void:
	request_remove()
