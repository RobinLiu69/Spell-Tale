extends Behavior

@export var component: Component

func initialize():
	pass

func component_changes(entity):
	if !entity.is_on_floor():
		component.change_behavior("FallBehavior")

	if entity.is_on_floor() and !entity.velocity.y:
		component.change_behavior("IdleBehavior")

func update_behavior(delta):
	var entity = component.entity

	do_jump(delta, entity)

	component_changes(entity)
	
func do_jump(delta, entity):
	entity.velocity.y = entity.JUMP_VELOCITY
	entity.jump = false
	
	entity.acceleration = entity.movement_direction * entity.SPEED * entity.speed_multiplier
	entity.velocity.x = entity.acceleration

	if entity.velocity.x < 0:
		entity.player_sprite.flip_h = true
	elif entity.velocity.x > 0:
		entity.player_sprite.flip_h = false
