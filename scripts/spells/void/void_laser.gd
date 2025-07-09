class_name VoidLaser
extends Spell

@export var beam_length := 1000.0
@onready var beam: Line2D = $Beam
@onready var ray_cast: RayCast2D = $RayCast
@onready var laser_end: Sprite2D = $LaserEnd
@onready var timer: Timer = $Timer
@onready var hitbox_component: Node2D = $HitboxComponent


@onready var collider_list: Array[Player] = []

func _ready() -> void:
	damage = 0.01
	_set_length(beam_length)
	ray_cast.target_position.x = beam_length
	

func cast():
	if ray_cast:
		ray_cast.force_raycast_update()
		_check_laser_hit()


func _physics_process(delta: float) -> void:
	_check_laser_hit()

func hit(hurtbox: HurtboxComponent):	
	if hurtbox.entity not in collider_list:
		var slow = SlowEffect.new(timer.wait_time+10)
		slow.slow_multiplier = 0.5
		hurtbox.entity.status_effect_manager.add_effect(slow, hurtbox.entity)
		collider_list.append(hurtbox.entity)
		print("add slow")

func _process(delta: float) -> void:
	if source:
		position = source.spell_con.marker_2d.global_position
		rotation = source.spell_con.marker_2d.global_rotation


func _check_laser_hit():
	if ray_cast.is_colliding():
		_set_length(to_local(ray_cast.get_collision_point()).x)
	else:
		_set_length(beam_length)

func _set_length(length: float):
	beam.points[1].x = length
	laser_end.position.x = length
	hitbox_component.position.x = length


func _on_timer_timeout() -> void:
	request_remove()
