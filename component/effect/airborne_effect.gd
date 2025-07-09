extends Effect
class_name AirborneEffect

func apply():
	var behavior_comp = component.entity.get_node("BehaviorComponent")
	if behavior_comp:
		old_behavior = behavior_comp.current_behavior
		behavior_comp.change_behavior("AirborneBehavior")

func update(delta: float):
	if component.entity.is_on_floor():
		is_stopped = true

func remove():
	var behavior_comp = component.entity.get_node("BehaviorComponent")
	if behavior_comp and old_behavior:
		behavior_comp.set_behavior(old_behavior)
