class_name FloatEffect
extends Effect

func apply():
	component.entity.gravity_scale = 0
	component.entity.velocity.y = -50

func update(delta):
	component.entity.velocity.y = -50

func remove():
	component.entity.gravity_scale = 1
