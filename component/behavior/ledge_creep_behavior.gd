extends Behavior

func update_behavior(delta):
	var entity = component.entity

	entity.velocity.x = entity.movement_direction * entity.creep_speed
	entity.acceleration = entity.velocity.x  # 給其他系統看

	if entity.jump:
		component.change_behavior("JumpBehavior")
		return
		
	elif !entity.is_on_floor():
		component.change_behavior("FallBehavior")
		return
		
	elif abs(entity.movement_direction) < 0.01:
		component.change_behavior("IdleBehavior")
		return
		
	elif entity.check_ground_ahead():
		component.change_behavior("WalkBehavior")
		return
