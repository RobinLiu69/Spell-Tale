extends Behavior

@export var component: Component

func initialize():
	pass

func behavior_changes(entity):
	if !entity.velocity.x:
		component.change_behavior("IdleBehavior")

	if entity.jump:
		component.change_behavior("JumpBehavior")

	if entity.movement_direction:
		component.change_behavior("WalkBehavior")

	if !entity.is_on_floor():
		component.change_behavior("FallBehavior")

func update_behavior(delta):
	var entity = component.entity
	entity.velocity.x = 0
	entity.acceleration = 0
	behavior_changes(entity)
