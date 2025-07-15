extends Behavior
class_name FloatBehavior

@export var float_power: float = 1000
@export var max_height: float = 300
@export var i: float = 0

func enter():
	i = 0  
	component.entity.velocity = Vector2.ZERO
	component.entity.disable_input = true
	component.entity.disable_skill = true
	
func component_changes(entity):
	if !entity.is_on_floor():
		change_to("AirborneBehavior")
	else:
		change_to("IdleBehavior")

func update_behavior(delta):
	var entity = component.entity
	
	if i < max_height:
		i += float_power * delta
	
		entity.velocity.y = -i
	else:
		component_changes(entity)

func exit():
	component.entity.disable_input = false
	component.entity.disable_skill = false
