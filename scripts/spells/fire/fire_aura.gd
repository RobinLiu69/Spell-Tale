class_name FireAura
extends Spell

@onready var timer := $DamageTimer
@onready var anim := $AnimationPlayer
@onready var sprite := $Sprite2D
@onready var area2d := $Arae2D

var damage_per_second := 1.0
var ticks_per_second := 2
var duration := 5.0


func _ready() -> void:
	print(6)
	damage = damage_per_second / ticks_per_second
	timer.wait_time = 1.0 / ticks_per_second
	timer.start()

	if anim:
		anim.play("fire_aura_playing")

	$LifeTimer.start(duration)



func _process(delta) -> void:
	if source:
		global_position = source.global_position


func _on_damage_timer_timeout() -> void:
	if !is_multiplayer_authority():
		return

	for body in area2d.get_overlapping_bodies():
		if body is Player:
			body.take_damage.rpc_id(body.get_multiplayer_authority(), damage, source_path)


@rpc("call_local")
func remove_self() -> void:
	queue_free()


func _on_life_timer_timeout() -> void:
	remove_self()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	anim.play("fire_aura_playing")
