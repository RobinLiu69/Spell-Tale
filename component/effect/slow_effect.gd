class_name SlowEffect
extends Effect

var original_speed: float

func apply():
	var move_comp = component.entity.get_node_or_null("MoveComponent")
	if move_comp:
		original_speed = move_comp.speed
		move_comp.speed *= level

func remove():
	var move_comp = component.entity.get_node_or_null("MoveComponent")
	if move_comp:
		move_comp.speed = original_speed
