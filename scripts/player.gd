class_name Player
extends CharacterBody2D

@onready var marker := $SpellCon/Marker2D
@onready var health_bar := $HealthBar

const SPEED = 300.0
const JUMP_VELOCITY = -500.0

var acceleration = 0.0
var health = 10.0


var spell_1: String
var spell_2: String

func _enter_tree() -> void:
	set_multiplayer_authority(int(str(name)))

func _ready() -> void:
	health_bar.init_health(health)
	
	spell_1 = "fireball"
	spell_2 = "void_snare"
	
	$CamOrigin/Camera2D.enabled = is_multiplayer_authority()
	if !is_multiplayer_authority():
		$PlayerSprite.modulate = Color.RED
	
func _physics_process(delta: float) -> void:
	if !is_multiplayer_authority():
		return
	
	var pos := get_global_mouse_position()
	
	$SpellCon.look_at(pos)
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	
	if Input.is_action_just_pressed("special_1"):
		cast.rpc(multiplayer.get_unique_id(), spell_1, pos)
	elif Input.is_action_just_pressed("special_2"):
		cast.rpc(multiplayer.get_unique_id(), spell_2, pos)
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
func cast(caster_pid: int, spell_name: String, target_pos: Vector2 = Vector2.ZERO):
	print(str(caster_pid)+"spawn")
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
		spell.transform = marker.global_transform
	elif cast_at == "target_pos":
		spell.position = target_pos
	elif cast_at == "self":
		pass


@rpc("any_peer", "call_local")
func take_damage(damage: float, source_path: String):
	var source_node = get_node_or_null(source_path)
	if source_node:
		print("get damaged "+str(damage)+" from ", Player)
		print(health_bar.health)
		health -= damage
		health_bar.health = health
		print(health_bar.health)
