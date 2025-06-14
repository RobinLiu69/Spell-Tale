extends Component2D

@export var entity : CharacterBody2D

func update_component(delta):
	self.look_at(entity.mouse_pos)
