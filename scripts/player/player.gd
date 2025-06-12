extends CharacterBody2D
class_name Player

@onready var marker := $SpellConComponent/Marker2D
@onready var health_bar := $HealthBar
@onready var status_effect_manager: Node2D = $StatusEffectManager
@onready var camera_2d := $Camera2D
@onready var player_sprite := $PlayerSprite
@onready var spell_con := $SpellConComponent
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
	
	component_tree_handler(delta)
	component_handler(delta)
	
	move_and_slide()

func component_tree_handler(delta):
	var component_trees = [
		get_node_or_null("BehaviorComponentTree"),
	]
	for component_tree in component_trees:
		if is_instance_valid(component_tree):
			component_tree.update_tree(delta)

func component_handler(delta):
	var components = [
		get_node_or_null("SpellConComponent"),
		get_node_or_null("InputComponent"),
		get_node_or_null("CameraComponent")
	]
	for component in components:
		if is_instance_valid(component):
			component.update_component(delta)
	
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
