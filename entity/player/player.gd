extends CharacterBody2D
class_name Player

@onready var spell_con_component: Node2D = $SpellConComponent
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

var acceleration = 0.0
var speed_multiplier := 1.0

var mouse_pos
var jump = false

var movement_direction = 0

var spell_1: String
var spell_2: String
var spell_3: String

var can_move := true
var can_cast := true

func _enter_tree() -> void:
	set_multiplayer_authority(int(str(name)))

func _ready() -> void:
	spell_1 = Global.spell_1
	spell_2 = Global.spell_2
	spell_3= Global.spell_3
	
	camera_2d.enabled = is_multiplayer_authority()
	
	if !is_multiplayer_authority():
		player_sprite.modulate = Color.RED
	
func _physics_process(delta: float) -> void:
	if !is_multiplayer_authority():
		return
	
	mouse_pos = get_global_mouse_position()
	
	if can_move:
		component_handler(delta)
	
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


func request_cast(spell_name, target_pos):
	if not can_cast:
		return 
	spell_con_component.request_cast(spell_name, target_pos)


	
@rpc("call_local")
func place_totem(caster_pid: int, totem_name: String, position: Vector2, direction: Vector2):
	if not TotemRegistry.TOTEMS.has(totem_name):
		push_error("totem %s not found in registry" % totem_name)
		return
	var totem_info := TotemRegistry.get_totem_info(totem_name)
	var totem: Totem = totem_info.instantiate()
	totem.position = position
	totem.look_at(position + direction)
	totem.source = self
	totem.set_multiplayer_authority(caster_pid)
	get_parent().add_child(totem)
	totem.activate()
