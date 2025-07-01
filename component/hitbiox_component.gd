extends Component2D

@export var spell: Spell
@export var hitbox: Area2D

func _ready() -> void:
	hitbox.area_entered.connect(_on_area_2d_area_entered)
	hitbox.body_entered.connect(_on_area_2d_body_entered)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if !is_multiplayer_authority() or body is Player:
		return
	
	spell._request_remove()
	
	
func _on_area_2d_area_entered(area: Area2D) -> void:
	if !is_multiplayer_authority():
		return
		
	var hurtbox = area.get_parent()
	
	if hurtbox is HurtboxComponent:
		spell.hit(hurtbox)
	
