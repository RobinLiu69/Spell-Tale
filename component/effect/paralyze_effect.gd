class_name ParalyzeEffect
extends Effect

func apply():
	var behavior_comp = component.entity.get_node("BehaviorComponent")
	if behavior_comp:
		old_behavior = behavior_comp.current_behavior
		behavior_comp.change_behavior("paralyzed")
	# 建議：可中斷當前施法，或呼叫 interrupt_skill()
