class_name HealthComponent
extends Component

@export var health_bar: HealthBar

var health: float = 10.0

func _ready() -> void:
	health_bar.init_health(health)

func damage(attack: Attack):
	health -= attack.damage
	health_bar.health = health
