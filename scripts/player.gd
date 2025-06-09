class_name Player
extends CharacterBody2D

@onready var movement: MovementComponent = $MovementComponent
@onready var health: HealthComponent = $HealthComponent
@onready var spell: SpellComponent = $SpellComponent
@onready var totem: TotemComponent = $TotemComponent
@onready var camera_control: CameraFollowComponent = $CameraFollowComponent

func _enter_tree():
	set_multiplayer_authority(int(str(name)))

func _ready():
	spell.set_source(self)

	camera_control.set_enabled(is_multiplayer_authority())
	if !is_multiplayer_authority():
		$PlayerSprite.modulate = Color.RED

func _physics_process(delta: float) -> void:
	if !is_multiplayer_authority():
		return
	
	movement.process_input(delta)
	spell.update_spellcon(get_global_mouse_position())
	camera_control.update_offset(get_global_mouse_position())

	if Input.is_action_just_pressed("special_1"):
		spell.cast_spell(1, get_global_mouse_position())
	elif Input.is_action_just_pressed("special_2"):
		spell.cast_spell(2, get_global_mouse_position())
	elif Input.is_action_just_pressed("special_3"):
		spell.cast_spell(3, get_global_mouse_position())
	
	
	move_and_slide()
