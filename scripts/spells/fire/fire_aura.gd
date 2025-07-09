class_name FireAura
extends Spell

@onready var timer := $DamageTimer
@onready var anim := $AnimationPlayer
@onready var sprite := $Sprite2D

var damage_per_second := 1.0
var ticks_per_second := 2
var duration := 5.0


func _ready() -> void:
	damage = damage_per_second / ticks_per_second
	timer.wait_time = 1.0 / ticks_per_second
	timer.start()

	if anim:
		anim.play("fire_aura_playing")

	$LifeTimer.start(duration)


func hit(hurtbox: HurtboxComponent):
	var attack = Attack.new()
	attack.damage = damage
	hurtbox.damage.rpc(attack.serialize())
	


func _on_life_timer_timeout() -> void:
	await anim.animation_finished
	request_remove()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	anim.play("fire_aura_playing")
