extends Component

@export var entity: CharacterBody2D
@export var default_behavior: Behavior

@onready var current_behavior: Behavior

func _ready():
	current_behavior = default_behavior

func update_component(delta):
	entity.text_edit.text = current_behavior.name
	if is_instance_valid(current_behavior):
		current_behavior.update_behavior(delta)

func set_behavior(new_behavior):
	current_behavior = new_behavior

func change_behavior(new_behavior_name: String):
	var new_behavior = get_node_or_null(new_behavior_name)
	if !is_instance_valid(new_behavior):
		if not new_behavior_name:
			print("Error changing to ", new_behavior_name, " in ",entity.name, " at ", self.name, ".")

		change_behavior(default_behavior.name)
		return
	
	if new_behavior == current_behavior:
		return

	set_behavior(new_behavior)
