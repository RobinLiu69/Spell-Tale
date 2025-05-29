class_name FireAura
extends Spell

@onready var timer: Timer = $DamageTimer
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D

var damage_per_second := 1.0
var ticks_per_second := 2
var duration := 5.0


func _ready():
	print(6)
	damage = damage_per_second / ticks_per_second
	timer.wait_time = 1.0 / ticks_per_second
	timer.start()

	# 播動畫（如果你有設定）
	#if anim:
		#anim.play("idle")

	# 設定自動銷毀
	$LifeTimer.start(duration)



func _process(delta):
	# 持續跟隨 source
	if source:
		global_position = source.global_position


func _on_damage_timer_timeout() -> void:
	if !is_multiplayer_authority():
		return

	for body in get_overlapping_bodies():
		if body is Player:
			body.take_damage.rpc_id(body.get_multiplayer_authority(), damage, source_path)


@rpc("call_local")
func remove_self():
	queue_free()


func _on_life_timer_timeout() -> void:
	remove_self()
