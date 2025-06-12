extends CharacterBody2D
class_name Player

@onready var marker := $SpellConComponent/Marker2D
@onready var health_bar := $HealthBar
@onready var status_effect_manager: Node2D = $StatusEffectManager
@onready var camera_2d := $Camera2D
@onready var player_sprite := $PlayerSprite
@onready var spell_con := $SpellConComponent
@onready var text_edit := $TextEdit

@export var JUMP_VELOCITY: float = -500.0
@export var SPEED: float = 300.0
var acceleration = 0.0
var speed_multiplier := 1.0

var mouse_pos

var jump = false
var health = 10.0
var movement_direction = 0

var spell_1: String
var spell_2: String
var spell_3: String

func _enter_tree() -> void:
	set_multiplayer_authority(int(str(name)))

func _ready() -> void:
	health_bar.init_health(health)
	
	spell_1 = "fireball"
	spell_2 = "void_snare"
	spell_3= "void_laser"
	
	camera_2d.enabled = is_multiplayer_authority()
	
	if !is_multiplayer_authority():
		player_sprite.modulate = Color.RED
	
func _physics_process(delta: float) -> void:
	if !is_multiplayer_authority():
		return
	
	mouse_pos = get_global_mouse_position()
		
	var offset_x = (mouse_pos.x - global_position.x) / (1920.0 / 50.0)
	var offset_y = (mouse_pos.y - global_position.y) / (1080.0 / 50.0)
	
	#camera_2d.offset.lerp(Vector2(offset_x, offset_y), 0.1)
	camera_2d.offset = Vector2(offset_x, offset_y)
		
	
	input_handler()
	
	component_tree_handler(delta)
	component_handler(delta)
	
	move_and_slide()

func component_tree_handler(delta):
	var behavior_component_tree = get_node_or_null("BehaviorComponentTree")
	
	if is_instance_valid(behavior_component_tree):
		behavior_component_tree.update_tree(delta)
	
func component_handler(delta):
	var spell_con_component = get_node_or_null("SpellConComponent")
	
	if is_instance_valid(spell_con_component):
		spell_con_component.update_component()

func input_handler():	
	$lefttex.visible = Input.is_action_pressed("left")
	$righttex.visible = Input.is_action_pressed("right")
	if Input.is_action_pressed("left") == Input.is_action_pressed("right"):
		movement_direction = 0
	elif Input.is_action_pressed("left"):
		movement_direction = -1
	elif Input.is_action_pressed("right"):
		movement_direction = 1
		
	if Input.is_action_pressed("jump") and is_on_floor():
		jump = true

	if Input.is_action_just_pressed("special_1"):
		cast.rpc(multiplayer.get_unique_id(), spell_1, mouse_pos)
	elif Input.is_action_just_pressed("special_2"):
		cast.rpc(multiplayer.get_unique_id(), spell_2, mouse_pos)
	elif Input.is_action_just_pressed("special_3"):
		cast.rpc(multiplayer.get_unique_id(), spell_3, mouse_pos)
	
@rpc("call_local")
func cast(caster_pid: int, spell_name: String, target_pos: Vector2 = Vector2.ZERO):
	if not SpellRegistry.SPELLS.has(spell_name):
		push_error("spell %s not found in registry" % spell_name)
		return
	var spell_info := SpellRegistry.get_spell_info(spell_name)
	var cast_at: String = spell_info[0]
	var spell: Spell = spell_info[-1].instantiate()
	spell.source = self
	spell.source_path = self.get_path()
	spell.set_multiplayer_authority(caster_pid)
	get_parent().add_child(spell)
	
	if cast_at == "marker":
		spell.position = marker.global_position
		spell.rotation = marker.global_rotation
	elif cast_at == "target_pos":
		spell.position = target_pos
	elif cast_at == "self":
		pass
	spell.cast()
	
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

@rpc("any_peer", "call_local")
func take_damage(damage: float, source_path: String):
	var source_node = get_node_or_null(source_path)
	if source_node:
		print("get damaged "+str(damage)+" from ", Player)
		print(health_bar.health)
		health -= damage
		health_bar.health = health
		print(health_bar.health)
