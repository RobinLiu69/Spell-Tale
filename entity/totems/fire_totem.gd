class_name FireTotem
extends Totem

var health: float = 5.0

@onready var fire_timer = $FireTimer
@onready var flame_duration = $FlameDuration
@onready var flame_area = $FlameArea
@onready var anim = $AnimationPlayer

func _ready():
	fire_timer.wait_time = 2.0
	flame_duration.wait_time = 1.0
	fire_timer.start()
	flame_area.monitoring = false

func _on_fire_timer_timeout():
	anim.play("start_flame")
	flame_area.monitoring = true
	flame_duration.start()

func _on_flame_duration_timeout() -> void:
	flame_area.monitoring = false

func _on_flame_area_body_entered(body):
	if body.is_in_group("enemies"):
		body.take_damage(2)

func take_damage(amount: int):
	health -= amount
	if health <= 0:
		queue_free()
