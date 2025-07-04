extends Node
class_name Behavior

@export var component: Component

func change_to(name: String) -> void:
	if component:
		component.change_behavior(name)

func enter() -> void:
	pass

func exit() -> void:
	pass
