extends Component

@export var tree: ComponentTree

func initialize():
	pass

func component_changes(entity):
	if !entity.velocity.x:
		tree.change_component("IdleComponent")

	if entity.jump:
		tree.change_component("JumpComponent")

	if entity.movement_direction:
		tree.change_component("WalkComponent")

	if !entity.is_on_floor():
		tree.change_component("FallComponent")

func update_component(delta):
	var entity = tree.entity
	entity.velocity.x = 0
	entity.acceleration = 0
	component_changes(entity)
