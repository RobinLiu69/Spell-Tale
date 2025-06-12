extends Component

@export var tree: ComponentTree

func initialize():
	pass

func component_changes(entity):
	if !entity.velocity.x:
		tree.change_component("IdleComponent")

	if entity.jump:
		tree.change_component("JumpComponent")

	if !entity.is_on_floor():
		tree.change_component("FallComponent")

func update_component(delta):
	var entity = tree.entity
	
	do_movement(delta, entity)
	
	component_changes(entity)

func do_movement(delta, entity):
	entity.acceleration = entity.movement_direction * entity.SPEED * entity.speed_multiplier

	entity.velocity.x = entity.acceleration

	if entity.velocity.x < 0:
		entity.player_sprite.flip_h = true
	elif entity.velocity.x > 0:
		entity.player_sprite.flip_h = false
