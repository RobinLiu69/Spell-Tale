extends Component

@export var tree: ComponentTree

func initialize():
	pass

func component_changes(entity):
	if !entity.is_on_floor():
		tree.change_component("FallComponent")

	if entity.is_on_floor() and !entity.velocity.y:
		tree.change_component("IdleComponent")

func update_component(delta):
	var entity = tree.entity

	do_jump(delta, entity)

	component_changes(entity)
	
func do_jump(delta, entity):
	entity.velocity.y = entity.JUMP_VELOCITY
	entity.jump = false
	
	entity.velocity.x = entity.acceleration
