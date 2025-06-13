class_name SlowEffect
extends StatusEffect

var slow_multiplier := 0.5

func apply(target: Player):
	target.speed_multiplier *= slow_multiplier

func remove(target: Player):
	target.speed_multiplier /= slow_multiplier
