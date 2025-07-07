extends Control

@onready var player_hp_bar := $MarginContainer/PlayerPanel/HealthBar
@onready var player_mana_bar := $MarginContainer/PlayerPanel/ManaBar
@onready var player_skill_container := $MarginContainer/PlayerPanel/SkillGroup
@onready var player_name_label := $MarginContainer/PlayerPanel/Label

@onready var enemy_hp_bar := $MarginContainer/EnemyPanel/HealthBar
@onready var enemy_mana_bar := $MarginContainer/EnemyPanel/ManaBar
@onready var enemy_skill_container := $MarginContainer/EnemyPanel/SkillGroup
@onready var enemy_name_label := $MarginContainer/EnemyPanel/Label

var local_player: Node = null
var remote_player: Node = null
var enemy_skill_icons := []
var revealed_spell_ids := []

# 自定義屬性顏色
var element_colors = {
	"fire": Color(1, 0.3, 0.3),
	"water": Color(0.3, 0.6, 1),
	"earth": Color(0.6, 0.4, 0.2),
	"grass": Color(0.4, 0.8, 0.4),
	"electric": Color(1, 1, 0.3),
	"light": Color(1, 1, 1),
	"dark": Color(0.4, 0.4, 0.6)
}

func assign_player_roles():
	for player in get_tree().get_nodes_in_group("players"):
		if str(player.name) == str(multiplayer.get_unique_id()):
			local_player = player
		else:
			remote_player = player

func _ready():
	assign_player_roles()
	connect_health_signals()
	connect_mana_signals()
	init_player_ui()
	init_enemy_ui()

func init_player_ui():
	player_name_label.text = "You"
	if player_hp_bar:
		player_hp_bar.init_health(10)
	
	if Global.player_mana_component and Global.selected_element != "":
		print(Global.player_mana_component, Global.selected_element)
		var mana = Global.player_mana_component
		var element = Global.selected_element
		player_mana_bar.init_mana(mana.max_mana.get(element, 10))
		mana.mana_changed.connect(update_player_mana)
		
		player_mana_bar.set_bar_color(element_colors.get(element, Color.WHITE))
	
	build_skill_ui([Global.spell_1, Global.spell_2, Global.spell_3], player_skill_container, true)

func init_enemy_ui():
	enemy_name_label.text = "Opponent"
	if enemy_hp_bar:
		enemy_hp_bar.init_health(10)  # 固定最大血量為 10
	print(Global.enemy_mana_component," ",Global.enemy_element)
	if Global.enemy_mana_component:
		var mana = Global.enemy_mana_component
		var element = Global.enemy_element
		enemy_mana_bar.init_mana(mana.max_mana.get(element, 10))
		mana.mana_changed.connect(update_enemy_mana)
		enemy_mana_bar.set_bar_color(element_colors.get(element, Color.WHITE))

	enemy_skill_icons = build_skill_ui(["?", "?", "?"], enemy_skill_container, false)
	print("Enemy Mana:", Global.enemy_mana_component)

func build_mp_ui(mana_component: Dictionary, container: Node):
	for child in container.get_children():
		child.queue_free()

	var current: Dictionary = mana_component.get("current_mana", {})
	var max: Dictionary = mana_component.get("max_mana", {})

	for element in current.keys():
		var bar = TextureProgressBar.new()
		bar.min_value = 0
		bar.max_value = max.get(element, 10)
		bar.value = current.get(element, 0)
		bar.custom_minimum_size = Vector2(60, 10)
		bar.modulate = element_colors.get(element, Color(1, 1, 1))
		container.add_child(bar)

func build_skill_ui(spell_ids: Array[String], container: Node, is_player: bool) -> Array:
	for child in container.get_children():
		child.queue_free()

	var skill_boxes = []

	for id in spell_ids:
		var box = VBoxContainer.new()
		box.alignment = BoxContainer.ALIGNMENT_CENTER

		var icon = TextureRect.new()
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		icon.expand = true
		icon.custom_minimum_size = Vector2(48, 48)

		var label = Label.new()

		if id == "?":
			icon.texture = preload("res://resources/icons/unknown.png")
			label.text = "???"
		else:
			var info = SpellRegistry.get_spell_info(id)
			icon.texture = load(info.get("icon", ""))
			label.text = "%s" % [info.get("name")]

		box.add_child(icon)
		box.add_child(label)
		container.add_child(box)
		skill_boxes.append({"icon": icon, "label": label})

	return skill_boxes

func update_enemy_skill(index: int, spell_id: String):
	# 如果這個 spell 已經顯示過，就跳過
	if revealed_spell_ids.has(spell_id):
		return
	revealed_spell_ids.append(spell_id)

	var info = SpellRegistry.get_spell_info(spell_id)
	var new_text := "%s" % [info.get("name")]

	# 如果 index 合法，直接指定欄位更新
	if index >= 0 and index < enemy_skill_icons.size():
		var icon = enemy_skill_icons[index]["icon"]
		var label = enemy_skill_icons[index]["label"]
		icon.texture = load(info.get("icon", ""))
		label.text = new_text
		return

	# 否則自動找第一個 "???" 欄位更新
	for skill in enemy_skill_icons:
		if skill["label"].text == "???":
			skill["icon"].texture = load(info.get("icon", ""))
			skill["label"].text = new_text
			return



func connect_health_signals():
	if local_player and local_player.has_node("HealthComponent"):
		var hc = local_player.get_node("HealthComponent")
		hc.health_changed.connect(update_player_health)
	if remote_player and remote_player.has_node("HealthComponent"):
		var hc = remote_player.get_node("HealthComponent")
		hc.health_changed.connect(update_enemy_health)

func update_player_health(new_health: float):
	if player_hp_bar:
		player_hp_bar.health = new_health

func update_enemy_health(new_health: float):
	if enemy_hp_bar:
		enemy_hp_bar.health = new_health
		
func update_player_mana(current_mana: Dictionary):
	var element = Global.selected_element
	if player_mana_bar:
		var val = current_mana.get(element, 0)
		player_mana_bar.current_mana = val
		print("player mana updated: ", val)
		

func update_enemy_mana(current_mana: Dictionary):
	var element = Global.enemy_element
	if enemy_mana_bar:
		var val = current_mana.get(element, 0)
		enemy_mana_bar.set_mana(val)
		print("enemy mana updated:", val)
		
func connect_mana_signals():
	if local_player and local_player.has_node("ManaComponent"):
		var mc = local_player.get_node("ManaComponent")
		var element = Global.selected_element
		player_mana_bar.init_mana(mc.max_mana.get(element, 10))
		player_mana_bar.set_bar_color(element_colors.get(element, Color.WHITE))
		mc.mana_changed.connect(update_player_mana)
		update_player_mana(mc.current_mana)

	if remote_player and remote_player.has_node("ManaComponent"):
		var mc = remote_player.get_node("ManaComponent")
		var element = Global.enemy_element
		enemy_mana_bar.init_mana(mc.max_mana.get(element, 10))
		enemy_mana_bar.set_bar_color(element_colors.get(element, Color.WHITE))
		mc.mana_changed.connect(update_enemy_mana)
		update_enemy_mana(mc.current_mana)
