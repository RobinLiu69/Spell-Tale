extends Component2D

@export var entity: CharacterBody2D
@export var mana_component: ManaComponent
@export var spell_cast_network_component: SpellCastNetworkComponent
@export var cooldown_component: CooldownComponent

@onready var marker_2d: Marker2D = $Marker2D


func update_component(delta):
	self.look_at(entity.mouse_pos)

func request_cast(spell_name: String, target_pos: Vector2):
	var my_id = multiplayer.get_unique_id()

	var spell_info = SpellRegistry.get_spell_info(spell_name)
	var mana_cost = spell_info[1].get("mana_cost", {})
	var cooldown = spell_info[1].get("cooldown", 0.0)
	var global_cd = spell_info[1].get("global_cooldown", 0.0)

	if cooldown_component and cooldown_component.is_on_cooldown(spell_name):
		print("Spell", spell_name, "is on cooldown.")
		return

	var mana_component = entity.get_node_or_null("ManaComponent")
	if mana_component and not mana_component.has_enough_multi(mana_cost):
		print("Not enough mana to cast", spell_name)
		return

	if cooldown_component:
		if cooldown > 0:
			cooldown_component.set_cooldown(spell_name, cooldown)
		if global_cd > 0:
			cooldown_component.set_global_cooldown(global_cd)

	if is_multiplayer_authority():
		entity.get_node("SpellCastNetworkComponent").server_cast(spell_name, target_pos, my_id)
	else:
		entity.get_node("SpellCastNetworkComponent").rpc_id(1, "server_cast", spell_name, target_pos, my_id)
