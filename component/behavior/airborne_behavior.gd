extends Behavior
class_name AirborneBehavior

func initialize():
	component.entity.velocity = Vector2.ZERO
	component.entity.disable_input = true
	component.entity.disable_skill = true


func update_behavior(delta):
	if component.entity.is_on_floor():
		component.change_behavior(component.default_behavior.name)
