extends Marker2D 

func _ready() -> void:
	pass

func _process(delta: float):
	look_at(get_global_mouse_position())
	
func attack(source: CharacterBody2D) -> float:
	owner = source
	
	return false
