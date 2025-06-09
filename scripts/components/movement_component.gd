class_name MovementComponent
extends Node

@export var speed := 300.0
@export var jump_velocity := -500.0
@export var source: CharacterBody2D

@export_node_path("Sprite2D") var sprite_path: NodePath


var acceleration := 0.0
var speed_multiplier := 1.0

var sprite: Sprite2D

func _ready():
	if sprite_path:
		sprite = source.get_node(sprite_path)


func process_input(delta: float) -> void:
	if source == null:
		return

	# Add gravity
	if not source.is_on_floor():
		source.velocity += source.get_gravity() * delta

	# Move left/right
	var direction := Input.get_axis("left", "right")
	if source.is_on_floor():
		if direction:
			acceleration = direction * speed * speed_multiplier
		else:
			acceleration = move_toward(acceleration, 0, speed)
	source.velocity.x = acceleration

	if Input.is_action_just_pressed("jump") and source.is_on_floor():
		source.velocity.y = jump_velocity

	if source.velocity.x < 0:
		sprite.flip_h = true
	elif source.velocity.x > 0:
		sprite.flip_h = false
