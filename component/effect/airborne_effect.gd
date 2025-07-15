extends Effect
class_name AirborneEffect

func apply():
	var behavior_comp = component.entity.get_node("BehaviorComponent")
	var airborne_behavior = behavior_comp.get_node("AirborneBehavior")
	if behavior_comp:
		print("start")
		old_behavior = behavior_comp.current_behavior
		airborne_behavior.effect_id = effect_id
		behavior_comp.change_behavior("FloatBehavior")

func remove():
	var behavior_comp = component.entity.get_node("BehaviorComponent")
	if behavior_comp and old_behavior:
		print("exit")
		behavior_comp.set_behavior(old_behavior)
