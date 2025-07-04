extends Behavior

func initialize():
	pass

func component_changes(entity):
	if entity.is_on_floor():
		if entity.jump:
			change_to("JumpBehavior")
		elif entity.movement_direction:
			change_to("WalkBehavior")
		else:
			change_to("IdleBehavior")

func update_behavior(delta):
	var entity = component.entity
	
	entity.velocity.y += entity.get_gravity().y * delta
	
	entity.velocity.x = entity.acceleration
	
	component_changes(entity)
