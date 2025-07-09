class_name HealthComponent
extends Component

@export var health_bar: HealthBar

signal health_changed(new_health: float)

var health: float = 10.0
var is_dead: bool = false

func _ready() -> void:
	health_bar.init_health(health)

func damage(attack: Attack):
	health -= attack.damage
	print(health)
	health_bar.health = health
	emit_signal("health_changed", health)
	
	if health <= 0 and not is_dead:
		is_dead = true
		owner.die()
		print("peer ",multiplayer.get_unique_id()," is dead")
		
		
func reset():
	is_dead = false
	health = 10
	emit_signal("health_changed", health)
