extends Component

@export var tree: ComponentTree

func initialize():
	pass

func component_changes(entity):
	if entity.is_on_floor():
		if entity.movement_direction:
			tree.change_component("WalkComponent")
		else:
			tree.change_component("IdleComponent")

func update_component(delta):
	var entity = tree.entity
	
	entity.velocity.y += entity.get_gravity().y * delta
	
	entity.velocity.x = entity.acceleration
	
	component_changes(entity)
