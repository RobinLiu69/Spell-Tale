extends Node
class_name Component

@export var tree: ComponentTree

func initialize():
	pass

func update(delta):
	var entity = tree.entity
	
	if entity.movement_direction:
		tree.change_component("RunComponent")
	
	if entity.jump:
		tree.change_component("JumpComponent")
