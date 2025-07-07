extends Node2D

@export var rabbit: Node2D
@onready var movement_con: Node2D = $MovementCon
@onready var anim: AnimationPlayer = $AnimationPlayer

@export var offset := Vector2(-50, 20)
@export var float_amplitude := 20.0
@export var float_speed := 1.5


@export var horizontal_speed := 5.0
@export var vertical_speed := 5.0

var target_position: Vector2

func _ready():
	target_position = movement_con.global_position

func _process(delta):
	if rabbit == null:
		return

	var facing_left = rabbit.scale.x < 0 or rabbit.get("flip_h")
	offset.x = -abs(offset.x) if !facing_left else abs(offset.x)

	var desired_position = rabbit.global_position + offset

	var time := Time.get_ticks_msec() / 1000.0
	var float_offset = sin(time * float_speed) * float_amplitude
	desired_position.y += float_offset

	target_position.x = lerp(target_position.x, desired_position.x, delta * horizontal_speed)
	target_position.y = lerp(target_position.y, desired_position.y, delta * vertical_speed)

	movement_con.global_position = target_position

func flash():
	anim.stop()
	anim.play("flash")
