class_name HealthComponent
extends Node

@export var max_health := 10.0
@export var health_bar: Node
@export var source: Node2D

var health: float

func _ready():
	health = max_health
	if health_bar.has_method("init_health"):
		health_bar.init_health(health)

@rpc("any_peer", "call_local")
func take_damage(damage: float, source_path: String):
	var source_node = get_node_or_null(source_path)
	if source_node:
		print("get damaged ", damage, " from ", source_node.name)
		health -= damage
		if health_bar.has("health"):
			health_bar.health = health
