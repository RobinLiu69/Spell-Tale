extends Spell
class_name WaterOrbSpell

@export var fire_interval := 0.5
@export var orb_sprite_scene: PackedScene
@export var orb_radius := 40.0

@onready var rotation_con: Node2D = $RotationCon

var spell_factory: SpellFactoryComponent = null
var fire_order: Array[Sprite2D] = []
var spell_ids: Array[int] = []
var timer: float = 0.0
var is_casting := false
var balls_fired := 0

func _ready():
	_generate_orbs()

func _generate_orbs():
	var count = 3
	for i in count:
		var angle = deg_to_rad(120 * i)
		var pos = Vector2(cos(angle), sin(angle)) * orb_radius
		
		var orb = orb_sprite_scene.instantiate() as Sprite2D
		orb.name = "WaterSprite" + str(i)
		orb.position = pos
		rotation_con.add_child(orb)
		fire_order.append(orb)

func cast():
	is_casting = true
	timer = 0.0
	balls_fired = 0

func _process(delta):
	if !is_casting:
		return

	rotation_con.rotation += delta * 2.5
	timer += delta

	if timer >= fire_interval and balls_fired < fire_order.size():
		_fire_waterball()
		timer = 0.0
		balls_fired += 1
		fire_interval -= 0.1

	if balls_fired >= fire_order.size():
		await get_tree().create_timer(0.2).timeout
		queue_free()

func _fire_waterball():
	if !multiplayer.is_server():
		return
	
	if balls_fired >= fire_order.size():
		return

	if spell_factory == null:
		var player = PlayerManager.get_player(caster_pid)
		if player:
			spell_factory = player.get_node("SpellFactoryComponent")
		else:
			printerr("Can't find player whose caster_pid is ", caster_pid)
			return
	
	var orb_sprite = fire_order[balls_fired]
	var orb_name = orb_sprite.name
	var spawn_pos = orb_sprite.global_position
	rotation = self.global_rotation
	
	print(fire_order)
	
	remove_orb_sprite.rpc(balls_fired)

	var new_spell_id = SpellManager.get_new_id()
	spawn_waterball.rpc(spawn_pos, rotation, new_spell_id)

@rpc("any_peer", "call_local")
func remove_orb_sprite(_index: int):
	if is_instance_valid(fire_order[_index]):
		fire_order[_index].queue_free()


@rpc("any_peer", "call_local")
func spawn_waterball(pos: Vector2, rot: float, _spell_id: int):
	if spell_factory == null:
		var player = PlayerManager.get_player(caster_pid)
		if player:
			spell_factory = player.get_node("SpellFactoryComponent")
		else:
			printerr("Can't find player whose caster_pid is ", caster_pid)
			return

	var spell = spell_factory.spawn_spell("water_orb", pos, caster_pid, _spell_id)
	spell.rotation = rot
	
