extends Behavior
class_name StunnedBehavior

func initialize():
	component.entity.velocity = Vector2.ZERO
	component.entity.acceleration = Vector2.ZERO
	component.entity.disable_input = true
	component.entity.disable_skill = true

func update_behavior(delta):
	component.entity.velocity = Vector2.ZERO
