extends Component

@export var entity: CharacterBody2D

func update_component(delta):	
	#entity.lefttex.visible = Input.is_action_pressed("left")
	#entity.righttex.visible = Input.is_action_pressed("right")
	if not entity.can_move:
		entity.movement_direction = 0
		entity.jump = false
	else:
		if Input.is_action_pressed("left") == Input.is_action_pressed("right"):
			entity.movement_direction = 0
		elif Input.is_action_pressed("left"):
			entity.movement_direction = -1
		elif Input.is_action_pressed("right"):
			entity.movement_direction = 1
		
		entity.jump = Input.is_action_pressed("jump")
	
	if entity.can_cast:
		if Input.is_action_just_pressed("special_1"):
			entity.request_cast(entity.spell_1, entity.mouse_pos)
		elif Input.is_action_just_pressed("special_2"):
			entity.request_cast(entity.spell_2, entity.mouse_pos)
		elif Input.is_action_just_pressed("special_3"):
			entity.request_cast(entity.spell_3, entity.mouse_pos)
	
	if Input.is_action_just_pressed("debug"):
		print(SpellManager.spell_dict)
