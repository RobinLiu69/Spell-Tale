extends CharacterBody2D
class_name Player

@onready var spell_con_component: Node2D = $SpellConComponent
@onready var cooldown_component: CooldownComponent = $CooldownComponent
@onready var health_bar := $HealthBar
@onready var status_effect_manager: Node2D = $StatusEffectManager
@onready var camera_2d := $Camera2D
@onready var player_sprite := $PlayerSprite
@onready var spell_con := $SpellConComponent
@onready var hurtbox_component := $HurtboxComponent

#Debug Use ------------------------
@onready var text_edit := $TextEdit
@onready var righttex  := $righttex
@onready var lefttex   := $lefttex
#----------------------------------
@export var JUMP_VELOCITY: float = -500.0
@export var SPEED: float = 300.0

@export var spell_1: String = "fireball"
@export var spell_2: String = "fire_aura"
@export var spell_3: String = "void_laser"

var acceleration := 0.0
var speed_multiplier := 1.0
var creep_speed := 150

var time_moving := 0.0
var mouse_pos
var jump = false

var movement_direction = 0

var can_move := true
var can_cast := true

func _enter_tree() -> void:
	set_multiplayer_authority(int(str(name)))

func _ready() -> void:
	camera_2d.enabled = is_multiplayer_authority()
	
	if !is_multiplayer_authority():
		player_sprite.modulate = Color.RED
	
func _physics_process(delta: float) -> void:
	if !is_multiplayer_authority():
		return
	
	mouse_pos = get_global_mouse_position()
	cooldown_component.update_component(delta)
	
	if can_move:
		component_handler(delta)
		update_movement_timer(delta)
	
	move_and_slide()

func component_handler(delta):
	var components = [
		get_node_or_null("BehaviorComponent"),
		get_node_or_null("SpellConComponent"),
		get_node_or_null("InputComponent"),
		get_node_or_null("CameraComponent")
	]
	for component in components:
		if is_instance_valid(component):
			component.update_component(delta)

func is_near_ledge() -> bool:
	if movement_direction < 0:
		return !$RayCastLeft.is_colliding()
	elif movement_direction > 0:
		return !$RayCastRight.is_colliding()
	return false

func check_ground_ahead() -> bool:
	if movement_direction < 0:
		return $RayCastLeft.is_colliding()
	elif movement_direction > 0:
		return $RayCastRight.is_colliding()
	return false

func update_movement_timer(delta: float):
	if abs(movement_direction) > 0.1:
		time_moving += delta
	else:
		time_moving = 0.0


func request_cast(spell_name, target_pos):
	if not can_cast:
		return 
	spell_con_component.request_cast(spell_name, target_pos)
