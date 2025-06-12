extends Behavior

@export var component: Component

func initialize():
	pass

func component_changes(entity):
	if entity.is_on_floor():
		if entity.jump:
			component.change_behavior("JumpBehavior")
		elif entity.movement_direction:
			component.change_behavior("WalkBehavior")
		else:
			component.change_behavior("IdleBehavior")

func update_behavior(delta):
	var entity = component.entity
	
	entity.velocity.y += entity.get_gravity().y * delta
	
	entity.velocity.x = entity.acceleration
	
	component_changes(entity)
