extends Control

@onready var category_dropdown: OptionButton = $UI/RightPanel/CategoryDropdown
@onready var spell_scroll := $UI/RightPanel/SpellScroll/SpellList
@onready var action_button := $UI/RightPanel/ActionButton
@onready var confirm_button := $UI/LeftPanel/ConfirmButton
@onready var fight_button := $UI/LeftPanel/FightButton
@onready var message_label := $UI/RightPanel/MessageLabel
@onready var notify_label := $UI/LeftPanel/NotifyLabel
@onready var character_preview_label := $UI/LeftPanel/CharacterPreviewLabel
@onready var tooltip_panel := $CanvasLayer/SpellTooltip
@onready var tooltip_name := $CanvasLayer/SpellTooltip/VBoxContainer/NameLabel
@onready var tooltip_desc := $CanvasLayer/SpellTooltip/VBoxContainer/DescLabel
@onready var spell_info_label := $UI/RightPanel/SpellInfoLabel
@onready var spell_name_label: Label = $UI/RightPanel/SpellNameLabel
@onready var preview_sprite := $UI/LeftPanel/CharacterPreview/ChracterSelector/PreviewSprite
@onready var character_name := $UI/LeftPanel/CharacterName




@onready var selected_spell_slots := [
	$UI/LeftPanel/SpellSlots/QSpell/PanelContainer/QSlot,
	$UI/LeftPanel/SpellSlots/WSpell/PanelContainer/WSlot,
	$UI/LeftPanel/SpellSlots/ESpell/PanelContainer/ESlot
]
@onready var slot_labels := [
	$UI/LeftPanel/SpellSlots/QSpell/QLabel,
	$UI/LeftPanel/SpellSlots/WSpell/WLabel,
	$UI/LeftPanel/SpellSlots/ESpell/ELabel
]

const MAX_SELECTED := 3
var spell_data: Dictionary = {}
var selected_spell_ids: Array[String] = []
var current_preview_spell_id: String = ""
var button_map: Dictionary = {}
var tooltip_follow_mouse := false
var character_data := {}               
var character_list := []              
var current_character_index := 0



func _ready():
	load_spells("res://data/spells.json")
	load_character_data("res://data/characters.json")
	_load_preview_sprite()
	populate_categories()
	category_dropdown.connect("item_selected", Callable(self, "_on_category_selected"))
	action_button.connect("pressed", Callable(self, "_on_action_button_pressed"))
	$UI/LeftPanel/ConfirmAction.action = Callable(self, "_on_confirm_pressed")
	$UI/LeftPanel/FightAction.action = Callable(self, "_on_fight_pressed")
	$BackButtonAction.action = Callable(self,"_on_back_button_pressed")
	$UI/LeftPanel/CharacterPreview/ChracterSelector/LeftButtonAction.action = Callable(self,"_on_left_pressed")
	$UI/LeftPanel/CharacterPreview/ChracterSelector/RightButtonAction.action = Callable(self,"_on_right_pressed")
	update_ui_state()
	_update_character_preview()
	_update_spell_slots()

func _process(delta):
	if tooltip_follow_mouse and tooltip_panel.visible:
		var offset = Vector2(16, 16)
		var mouse_pos = get_viewport().get_mouse_position()
		var screen_size = get_viewport().get_visible_rect().size
		var tooltip_size = tooltip_panel.get_combined_minimum_size()
		var pos = mouse_pos + offset
		if pos.x + tooltip_size.x > screen_size.x:
			pos.x = screen_size.x - tooltip_size.x
		if pos.y + tooltip_size.y > screen_size.y:
			pos.y = screen_size.y - tooltip_size.y

		tooltip_panel.global_position = pos


func load_spells(path: String):
	var file = FileAccess.open(path, FileAccess.READ)
	if file:
		spell_data = JSON.parse_string(file.get_as_text())
		file.close()
	else:
		push_error("Spell JSON loading failed")
		
func load_character_data(path: String):
	var file := FileAccess.open(path, FileAccess.READ)
	if file:
		var json_text := file.get_as_text()
		var parsed = JSON.parse_string(json_text)
		if parsed != null:
			character_data = parsed
			character_list = character_data.keys()
		else:
			push_error("analizing character JSON failed")
		file.close()
	else:
		push_error("character JSON loading failed")


func populate_categories():
	var categories := []
	for spell in spell_data.values():
		var cat = spell.get("category", "misc")
		if not categories.has(cat):
			categories.append(cat)
			category_dropdown.add_item(cat.capitalize())

	
	if categories.size() > 0:
		category_dropdown.select(0)
		populate_spell_list_by_category(categories[0])


func _on_category_selected(index: int):
	var selected_cat = category_dropdown.get_item_text(index).to_lower()
	populate_spell_list_by_category(selected_cat)
	current_preview_spell_id = ""
	action_button.visible = false
	spell_info_label.visible = false
	spell_name_label.visible = false
	message_label.visible = false

func populate_spell_list_by_category(category: String):
	
	for child in spell_scroll.get_children():
		child.queue_free()

	
	for id in spell_data.keys():
		var spell = spell_data[id]
		if spell.get("category") == category:
			var button = TextureButton.new()
			button.name = id
			button.texture_normal = load(spell["icon"])
			button.custom_minimum_size = Vector2(96, 96)
			button.connect("pressed", Callable(self, "_on_spell_button_pressed").bind(id))
			
			button.connect("mouse_entered", Callable(self, "_on_spell_hover_entered").bind(id))
			button.connect("mouse_exited", Callable(self, "_on_spell_hover_exited"))
			
			spell_scroll.add_child(button)
			button_map[id] = button

func _on_spell_button_pressed(spell_id: String):
	current_preview_spell_id = spell_id
	var spell = spell_data.get(spell_id, {})
	spell_name_label.text = spell.get("name", "???") 
	spell_info_label.text = spell.get("description", "No description")
	update_ui_state()

func _on_action_button_pressed():
	if current_preview_spell_id == "":
		return
	message_label.text = ""
	if current_preview_spell_id in selected_spell_ids:
		_remove_spell(current_preview_spell_id)
		message_label.visible = true
		message_label.text = "%s removed !" % spell_data[current_preview_spell_id]["name"]
	elif selected_spell_ids.size() < MAX_SELECTED:
		_add_spell(current_preview_spell_id)
		message_label.visible = true
		message_label.text = "%s added !" % spell_data[current_preview_spell_id]["name"]
	elif selected_spell_ids.size() == MAX_SELECTED:
		message_label.visible = true
		message_label.text = "already choosed 3 different spells !"
	update_ui_state()

func _add_spell(spell_id: String):
	if selected_spell_ids.size() >= MAX_SELECTED:
		return
	selected_spell_ids.append(spell_id)
	_update_spell_slots()

func _remove_spell(spell_id: String):
	selected_spell_ids.erase(spell_id)
	_update_spell_slots()

func _update_spell_slots():
	for i in range(MAX_SELECTED):
		var slot = selected_spell_slots[i]
		var label = slot_labels[i]
		
			
		var label_prefix = ["Q Spell", "W Spell", "E Spell"][i]
		
		if i < selected_spell_ids.size():
			var spell = spell_data[selected_spell_ids[i]]
			slot.texture = load(spell["icon"])
			label.text = spell["name"]
		else:
			slot.texture = null
			label.text = label_prefix

func update_ui_state():
	action_button.visible = current_preview_spell_id != ""
	spell_name_label.visible = current_preview_spell_id != ""
	spell_info_label.visible = current_preview_spell_id != ""
	action_button.text = "Remove" if current_preview_spell_id in selected_spell_ids else "Add"
	confirm_button.disabled = selected_spell_ids.size() == 0
	fight_button.disabled = selected_spell_ids.size() != MAX_SELECTED
	

func _on_spell_hover_entered(spell_id: String):
	var spell = spell_data.get(spell_id, {})
	if spell.is_empty():
		return

	tooltip_name.text = spell.get("name", "???")
	tooltip_desc.text = spell.get("description", "No description")
	tooltip_panel.visible = true
	tooltip_follow_mouse = true 

func _on_spell_hover_exited():
	tooltip_panel.visible = false
	tooltip_follow_mouse = false 

func _on_confirm_pressed():
	if selected_spell_ids.size() == 3:
		Global.spell_1 = selected_spell_ids[0]
		Global.spell_2 = selected_spell_ids[1]
		Global.spell_3 = selected_spell_ids[2]
		fight_button.visible = true
		notify_label.visible = true
		notify_label.text = "Data saved, ready to battle !"
		update_ui_state()

func _on_fight_pressed():
	_on_confirm_pressed()
	print("Ready to fight with:", Global.spell_1, Global.spell_2, Global.spell_3)
	get_tree().change_scene_to_file("res://scenes/games/game.tscn")
	
func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://scenes/ui/modechoice.tscn")
	
func _load_preview_sprite():
	var texture = load("res://resources/images/players/rabbit/idle/player.png")
	preview_sprite.texture = texture
	
func _on_left_pressed():
	if character_list.size() > 1:
		current_character_index = (current_character_index - 1 + character_list.size()) % character_list.size()
		_update_character_preview()

func _on_right_pressed():
	if character_list.size() > 1:
		current_character_index = (current_character_index + 1) % character_list.size()
		_update_character_preview()


func _update_character_preview():
	if character_list.is_empty():
		print("empty character list")
		return
	var char_id = character_list[current_character_index]
	var char_info = character_data[char_id]

	var texture = load(char_info["texture_path"])
	preview_sprite.texture = texture


	character_name.text = char_info["name"]
	Global.selected_character = char_id
