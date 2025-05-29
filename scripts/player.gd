class_name Player
extends CharacterBody2D

@onready var marker: Marker2D = $SpellCon/Marker2D
var is_multiplayer_mode: bool = true


const SPEED = 300.0
const JUMP_VELOCITY = -500.0

var acceleration = 0.0

var spell_1: String
var spell_2: String

func _enter_tree() -> void:
	if is_multiplayer_mode:
		set_multiplayer_authority(int(str(name)))

func _ready() -> void:
	spell_1 = "fireball"
	spell_2 = "fire_aura"
	
	if is_multiplayer_mode:
		$CamOrigin/Camera2D.enabled = is_multiplayer_authority()
		if !is_multiplayer_authority():
			$PlayerSprite.modulate = Color.RED
	else:
		$CamOrigin/Camera2D.enabled = true
		$PlayerSprite.modulate = Color(1,1,1,1)
func _physics_process(delta: float) -> void:
	if is_multiplayer_mode && !is_multiplayer_authority():
		return
	$SpellCon.look_at(get_global_mouse_position())
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	
	if Input.is_action_just_pressed("special_1"):
		cast.rpc(multiplayer.get_unique_id(), spell_1)
	elif Input.is_action_just_pressed("special_2"):
		cast.rpc(multiplayer.get_unique_id(), spell_2)
	#elif Input.is_action_just_pressed("special_3") and spell_dict[3] != null:
		#cast.rpc(spell_dict[3])
	
	# Handle jump.

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	
	if is_on_floor():
		if direction:
			acceleration = direction * SPEED
		else:
			acceleration = move_toward(acceleration, 0, SPEED)

	velocity.x = acceleration

	if velocity.x < 0:
		$PlayerSprite.flip_h = true
	elif velocity.x > 0:
		$PlayerSprite.flip_h = false


	move_and_slide()

	
@rpc("call_local")
func cast(caster_pid: int, spell_name: String):
	if not SpellRegistry.SPELLS.has(spell_name):
		push_error("spell %s not found in registry" % spell_name)
		return
	var spell: Spell = SpellRegistry.get_spell(spell_name).instantiate()
	spell.source = self
	spell.set_multiplayer_authority(caster_pid)
	get_parent().add_child(spell)
	spell.transform = marker.global_transform

@rpc("any_peer")
func take_damage(damage: int, source: Player):
	pass
