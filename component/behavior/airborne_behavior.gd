extends Behavior
class_name AirborneBehavior

var effect_id: int = -1

func enter():
	component.entity.velocity = Vector2.ZERO
	component.entity.disable_input = true
	component.entity.disable_skill = true
	

func update_behavior(delta):
	var entity = component.entity
	if component.entity.is_on_floor():
		var pid = component.entity.get_multiplayer_authority()
	
		EffectManager.request_remove_effect.rpc_id(1, int(pid), effect_id)

		component.change_behavior(component.default_behavior.name)
	

func exit():
	component.entity.disable_input = false
	component.entity.disable_skill = false
	
