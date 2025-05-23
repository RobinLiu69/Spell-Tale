extends CharacterBody2D

signal health_changed

@export var speed: int = 20
@export var size: float = 1.0
@export var max_health: int = 10
@onready var player: AnimatedSprite2D = $AnimatedSprite2D
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var marker: Marker2D = $Marker
@onready var current_health: int = max_health
@onready var skills: Node2D = $Skills

var damage: int = 0
var physical_defence: int = 0
var elements_resistance: int = 0
var grass_defence: int = 0
var fire_defence: int = 0
var water_defence: int = 0
var poison_defence: int = 0
var electric_defence: int = 0

func _ready():
	health_changed.emit()
	# for weapon in weapons:
		# print(weapon.current_scene.scene_file_path)

func take_damage(attacker: CharacterBody2D, value: int) -> bool:
	value = current_health if current_health - value <= 0 else value
	current_health -= value
	health_changed.emit()
	if not alive():
		queue_free()
		print(name +" dead")
	return true


func get_input() -> Vector2:
	return Input.get_vector("left", "right", "up", "down")

func spells(delta: float) -> bool:
	
	if Input.is_action_just_pressed("special_1"):
		var skill_instance: CharacterBody2D = skills.skill_1.instantiate()
		get_tree().current_scene.add_child(skill_instance)
		skill_instance.rotation = marker.rotation
		skill_instance.global_position = marker.global_position
		
	
	return true
	
func movement(delta: float) -> bool:
	var direction: Vector2 = get_input()
	if direction:
		velocity = direction * speed * 10
		
		if velocity.x < 0:
			player.flip_h = true
		elif velocity.x > 0:
			player.flip_h = false

		return true
	else:
		velocity.x = move_toward(velocity.x, 0, speed * 150 * delta)
		velocity.y = move_toward(velocity.y, 0, speed * 150 * delta)
		return false

func handle_hit(attacker: CharacterBody2D, damage: int) -> bool:
	current_health -= damage
	health_changed.emit()
	return true


func alive() -> bool:
	return current_health > 0


func _process(delta: float):
	movement(delta)
	spells(delta)
	move_and_slide()
