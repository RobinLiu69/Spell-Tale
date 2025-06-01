class_name StatusEffect
extends Resource

var duration := 1.0
var elapsed := 0.0

func _init(_duration: float = 1.0):
	duration = _duration

func apply(target: Player):
	pass

func update(target: Player, delta: float):
	elapsed += delta

func remove(target: Player):
	pass

func is_finished() -> bool:
	return elapsed >= duration
