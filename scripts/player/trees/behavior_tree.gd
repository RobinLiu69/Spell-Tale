extends Node
class_name ComponentTree

@export var entity: CharacterBody2D
@export var default_component: Component

@onready var current_component: Component

func _ready():
	current_component = default_component

func set_component(new_component):
	current_component = new_component

func update_component(delta):
	current_component.update(delta)

func change_component(new_component_name):
	var new_component : Component = get_node_or_null(new_component_name)
	if !is_instance_valid(new_component):
		if not new_component_name:
			print("Error changing to ", new_component_name, " in ",
			entity.name, " at ", self.name, ".")
		change_component(default_component)
	
	if new_component == current_component:
		return
	
	set_component(new_component)
