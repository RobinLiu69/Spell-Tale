extends Behavior

func behavior_changes(entity):
	if entity.jump:
		component.change_behavior("JumpBehavior")
		return

	if entity.movement_direction:
		component.change_behavior("WalkBehavior")
		return

	if !entity.is_on_floor():
		component.change_behavior("FallBehavior")
		return

	if !entity.velocity.x:
		component.change_behavior("IdleBehavior")
		return

func update_behavior(delta):
	var entity = component.entity
	entity.velocity.x = 0
	entity.acceleration = 0
	behavior_changes(entity)
