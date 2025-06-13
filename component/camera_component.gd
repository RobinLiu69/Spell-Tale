extends Component

@export var entity: CharacterBody2D 

func update_component(delta):	
	var offset_x = (entity.mouse_pos.x - entity.global_position.x) / (1920.0 / 50.0)
	var offset_y = (entity.mouse_pos.y - entity.global_position.y) / (1080.0 / 50.0)
	
	entity.camera_2d.offset = Vector2(offset_x, offset_y)
