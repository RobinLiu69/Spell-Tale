extends Node
class_name Component

@export var tree: ComponentTree

const SPEED = 300.0

var acceleration = 0.0
var speed_multiplier := 1.0

func initialize():
	pass

func component_changes(entity):
	if !entity.movement_direction:
		tree.change_component("IdleComponent")
	
	if entity.jump:
		tree.change_component("JumpComponent")

func update(delta):
	var entity = tree.entity
	
	component_changes(entity)
	
	do_movement(delta, entity)

func do_movement(delta, entity):
	if entity.is_on_floor():
		if entity.movement_direction:
			acceleration = entity.movement_direction * SPEED * speed_multiplier
		else:
			acceleration = move_toward(acceleration, 0, SPEED)

	entity.velocity.x = acceleration

	if entity.velocity.x < 0:
		entity.player_sprite.flip_h = true
	elif tree.entity.velocity.x > 0:
		entity.player_sprite.flip_h = false
