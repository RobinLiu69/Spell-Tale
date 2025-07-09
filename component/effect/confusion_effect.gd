class_name ConfusionEffect
extends Effect

func apply():
	var behavior_comp = component.entity.get_node("BehaviorComponent")
	if behavior_comp:
		old_behavior = behavior_comp.current_behavior
		behavior_comp.change_behavior("confused")

	var mana_comp = component.entity.get_node_or_null("ManaComponent")
	if mana_comp:
		mana_comp.regen_enabled = false

func remove(	):
	var behavior_comp = component.entity.get_node("BehaviorComponent")
	if behavior_comp and old_behavior:
		behavior_comp.set_behavior(old_behavior)
	
	var mana_comp = component.entity.get_node_or_null("ManaComponent")
	if mana_comp:
		mana_comp.regen_enabled = true
