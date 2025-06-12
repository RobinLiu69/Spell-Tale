extends ComponentTree

@export var entity: CharacterBody2D
@export var default_component: Component

@onready var current_component: Component

func _ready():
	current_component = default_component

func update_tree(delta):
	entity.text_edit.text = current_component.name
	if is_instance_valid(current_component):
		current_component.update_component(delta)

func set_component(new_component):
	current_component = new_component

func change_component(new_component_name: String):
	#print(new_component_name)
	var new_component = get_node_or_null(new_component_name)
	if !is_instance_valid(new_component):
		if not new_component_name:
			print("Error changing to ", new_component_name, " in ",
			entity.name, " at ", self.name, ".")

		change_component(default_component.name)
		return
	
	if new_component == current_component:
		return

	set_component(new_component)
