class_name WaterOrb
extends Spell

@export var speed := 750
@export var lifetime := 3.0

var velocity := Vector2.RIGHT
var timer := 0.0

func _ready():
	damage = 1
	$ExisitingTimer.set_wait_time(5)
	$ExisitingTimer.start()

func _physics_process(delta):
	position += transform.x * speed * delta
	timer += delta
	
	if timer >= lifetime:
		request_remove()

func hit(hurtbox: HurtboxComponent):
	if hurtbox:
		var attack = Attack.new()
		attack.damage = damage
		hurtbox.damage.rpc(attack.serialize())
		request_remove()

func _on_exisiting_timer_timeout() -> void:
	request_remove()

func hit_body(_body):
	request_remove()
