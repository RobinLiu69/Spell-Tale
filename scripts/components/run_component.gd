extends Behavior

@export var component: Component

func initialize():
	pass
	#???

func component_changes(entity):
	if !entity.velocity.x:
		component.change_behavior("IdleBehavior")

	if entity.jump:
		component.change_behavior("JumpBehavior")

	if !entity.is_on_floor():
		component.change_behavior("FallBehavior")

func update_behavior(delta):
	var entity = component.entity
	
	do_movement(delta, entity)
	
	component_changes(entity)

func do_movement(delta, entity):
	entity.acceleration = entity.movement_direction * entity.SPEED * entity.speed_multiplier

	entity.velocity.x = entity.acceleration

	if entity.velocity.x < 0:
		entity.player_sprite.flip_h = true
	elif entity.velocity.x > 0:
		entity.player_sprite.flip_h = false
