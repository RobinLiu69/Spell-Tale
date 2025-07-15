class_name Game
extends Node2D

@export var player_scene: PackedScene
@onready var esc_menu: Control = $UI/EscMenu
@onready var multiplayer_scene = preload("res://scenes/ui/game/multiplayer.tscn")
@onready var modechoice_scene = preload("res://scenes/ui/modechoice.tscn")
@onready var result_scene = $UI/ResultUI
@onready var battle_UI_scene = $UI/Battle_UI
@onready var port_display: MarginContainer = $UI/PortDisplay
@onready var port: Label = $UI/PortDisplay/Port
@onready var port_in_game: Label = $UI/PortDisplayInGame/PortInGame
@onready var port_display_in_game: MarginContainer = $UI/PortDisplayInGame
@onready var count_down_label: Label = $UI/CountDownDisplay/CountDownLabel
@onready var count_down_display: MarginContainer = $UI/CountDownDisplay

var peer = ENetMultiplayerPeer.new()
var players: Array[Player] = []
var used_spawn_indices: Array[int] = []
const MAX_PLAYERS := 2
var local_player: Player = null

func _ready() -> void:
	randomize()
	Global.previous_scene_path = "res://scenes/ui/modechoice.tscn"
	if Global.is_multiplayer_mode:
		if $UI.has_node("Multiplayer"):
			return
		var multiplayer_screen = multiplayer_scene.instantiate()
		multiplayer_screen.game_scene_ref = self
		result_scene.game_scene_ref = self
		$UI.add_child(multiplayer_screen)
		$MultiplayerSpawner.spawn_function = add_player
		MatchManager.game_scene_ref = self
	else:
		peer.create_server(randi_range(1,9999))
		multiplayer.multiplayer_peer = peer
		get_tree().get_multiplayer().peer_disconnected.connect(_on_peer_disconnected)
		$MultiplayerSpawner.spawn_function = add_player
		$MultiplayerSpawner.spawn(multiplayer.get_unique_id())
		show_setup_battle_UI(Global.is_multiplayer_mode)
		Global.multiplayer_ui_status = false

func port_manifest() -> void:
	port_display.visible = true
	port.text = "Room has been successfully created, Port is: " + str(Global.server_port)
	port_in_game.text = "Room port is: " + str(Global.server_port)
	await get_tree().create_timer(5).timeout
	port_display.visible = false

func _input(event) -> void:
	if event.is_action_pressed("ui_cancel") and get_tree().current_scene.name == "Game":
		toggle_pause_menu()

func toggle_pause_menu():
	esc_menu.visible = !Global.menu_status
	
	if Global.is_multiplayer_mode:
		port_display_in_game.visible = !Global.menu_status
	Global.menu_status = !Global.menu_status

func host_room() -> void:
	await cleanup_multiplayer()
	peer = ENetMultiplayerPeer.new()
	var port = randi_range(10000,60000)
	Global.server_port = port
	var result = peer.create_server(port)
	if result != OK:
		print("Failed to create server, please retry: ", port)
	multiplayer.multiplayer_peer = peer
	var mp = get_tree().get_multiplayer()
	mp.peer_disconnected.connect(_on_peer_disconnected)
	mp.peer_connected.connect(_on_peer_connected)
	await get_tree().create_timer(0.1).timeout
	$MultiplayerSpawner.spawn_function = add_player
	$MultiplayerSpawner.spawn(multiplayer.get_unique_id())
	Global.multiplayer_ui_status = false
	get_node("UI/ResultUI").update_score_display(Global.player_1_score,Global.player_2_score)

func join_room() -> void:
	await cleanup_multiplayer()
	peer = ENetMultiplayerPeer.new()
	var port = Global.server_port
	var result = peer.create_client(Global.multiplayer_IP, port)
	if result != OK:
		print("Failed to connect server, please retry: ", port)
		return
	multiplayer.multiplayer_peer = peer
	var tree_mp = get_tree().get_multiplayer()
	tree_mp.peer_disconnected.connect(_on_peer_disconnected)
	tree_mp.server_disconnected.connect(_on_server_disconnected)
	tree_mp.connection_failed.connect(_on_connection_failed)
	Global.multiplayer_ui_status = false
	Global.achivement1_status = true
	get_node("UI/ResultUI").update_score_display(Global.player_1_score,Global.player_2_score)
	if not multiplayer.is_server():
		print("Client sending element to host:", Global.selected_element)
		rpc_id(1, "send_selected_element_to_host", Global.selected_element)
	
	
func exit_game(pid):
	if multiplayer.is_server():
		rpc("notify_clients_game_ending")
		await get_tree().create_timer(0.1).timeout
		cleanup_multiplayer()
	else:
		cleanup_multiplayer()
		

	for player in players:
		if is_instance_valid(player):
			player.queue_free()

func cleanup_multiplayer():
	if multiplayer.multiplayer_peer:
		multiplayer.multiplayer_peer.close()
		multiplayer.multiplayer_peer = null

	var new_multiplayer := SceneMultiplayer.new()
	get_tree().set_multiplayer(new_multiplayer)
	used_spawn_indices.clear()

func _on_peer_connected(pid):
	print("peer " + str(pid) + " joined")
	if players.size() >= 2:
		print("Room is full, rejecting new player.")
		return
	var player = $MultiplayerSpawner.spawn(pid)
	Global.achivement1_status = true
	if players.size() == MAX_PLAYERS and multiplayer.is_server():
		if result_scene.auto_rematch_on_rejoin:
			print("Auto rematch triggered due to client rejoin.")
			result_scene.auto_rematch_on_rejoin = false
			result_scene.start_rematch_for_both()
		else:
			MatchManager.reset_match()
			reset_game_state()
			rpc("start_battle")

func _on_peer_disconnected(pid):
	print("delete player")
	del_player(pid)

	if multiplayer.is_server():
		announce_host_win()

func _on_server_disconnected():
	print("Disconnected from server")
	cleanup_multiplayer()
	get_tree().change_scene_to_packed(modechoice_scene)

func _on_connection_failed():
	print("Connection to server failed")
	get_tree().change_scene_to_packed(modechoice_scene)

func add_player(pid) -> Node2D:
	if players.size() >= MAX_PLAYERS:
		print("Room is full. Rejecting connection from", pid)
		if multiplayer.is_server():
			rpc_id(pid, "kick_from_full_room")
		return null

	var player: Player = player_scene.instantiate()
	player.name = str(pid)

	var spawn_index := -1
	var level_children := $Level.get_child_count()
	for i in level_children:
		if not used_spawn_indices.has(i):
			spawn_index = i
			break
	if spawn_index == -1:
		spawn_index = 0
	used_spawn_indices.append(spawn_index)
	player.global_position = $Level.get_child(spawn_index).global_position

	if pid == multiplayer.get_unique_id():
		local_player = player
		$UI/EscMenu.player = player

	players.append(player)
	
	if player.has_node("HealthComponent"):
		var hc = player.get_node("HealthComponent")
		if pid == multiplayer.get_unique_id():
			if is_instance_valid(battle_UI_scene):
				hc.health_changed.connect(battle_UI_scene.update_player_health)
		else:
			if is_instance_valid(battle_UI_scene):
				hc.health_changed.connect(battle_UI_scene.update_enemy_health)	

	if player.has_node("ManaComponent"):
		var mc = player.get_node("ManaComponent")
		if pid == multiplayer.get_unique_id():
			Global.player_mana_component = mc
			if is_instance_valid(battle_UI_scene):
				mc.mana_changed.connect(battle_UI_scene.update_player_mana)
		else:
			Global.enemy_mana_component = mc
			
			
			if is_instance_valid(battle_UI_scene):
				battle_UI_scene.remote_player = player
				mc.mana_changed.connect(battle_UI_scene.update_enemy_mana)
	
	if pid == multiplayer.get_unique_id():
		rpc("receive_enemy_element", Global.selected_element)
	else:
		rpc_id(pid, "receive_enemy_element", Global.selected_element)

	return player

func show_countdown_ui(duration: int):
	count_down_display.visible = true
	count_down_label.text = "Battle Starts!"

func hide_countdown_ui():
	await get_tree().create_timer(3).timeout
	count_down_display.visible = false

func reset_game_state():
	used_spawn_indices.clear()

	for player in players:
		if not is_instance_valid(player):
			continue

		var spawn_index := -1
		for i in $Level.get_child_count():
			if not used_spawn_indices.has(i):
				spawn_index = i
				break
		if spawn_index == -1:
			spawn_index = 0
		used_spawn_indices.append(spawn_index)

		player.global_position = $Level.get_child(spawn_index).global_position

		if player.has_method("reset_state"):
			player.reset_state()  

	battle_UI_scene.reset_ui()
	for player in players:
		if player.has_node("HealthComponent"):
			var hc = player.get_node("HealthComponent")
			hc.reset()
			if int(player.name) == multiplayer.get_unique_id():
				battle_UI_scene.update_player_health(10.0)
			else:
				battle_UI_scene.update_enemy_health(10.0)
				
		if player.has_node("ManaComponent"):
			player.get_node("ManaComponent").reset()
			
func del_player(pid):
	rpc("_del_player", pid)
	
func show_setup_battle_UI(multiplayer_status: bool):
	if is_instance_valid(battle_UI_scene):
		battle_UI_scene.visible = true
		battle_UI_scene.local_player = local_player
		if not multiplayer_status:
			battle_UI_scene.remote_player = null
			battle_UI_scene.hide_enemy_ui()
		battle_UI_scene.assign_player_roles()
		battle_UI_scene.init_player_ui()
		battle_UI_scene.connect_health_signals()
		battle_UI_scene.connect_mana_signals()

func announce_host_win():
	var winner = "Host"
	result_scene.visible = true
	result_scene.show_client_exit_result(winner)
	
	
	esc_menu.visible = false
	port_display_in_game.visible = false
	
	print("Host wins due to opponent disconnect")


@rpc("any_peer","call_local")
func _del_player(pid):
	var player_node := get_node_or_null(str(pid))
	if player_node:
		if players.has(player_node):
			players.erase(player_node)
		player_node.queue_free()
	else:
		print("Player node ", pid, " 不存在或已被釋放")

	if esc_menu.player and str(esc_menu.player.name) == str(pid):
		esc_menu.player = null

@rpc("authority")
func notify_clients_game_ending():
	print("Host is exiting")
	Global.is_multiplayer_mode = false
	await cleanup_multiplayer()
	get_tree().change_scene_to_packed(modechoice_scene)
	AudioManager.play_bgm()

@rpc("authority", "call_remote")
func kick_from_full_room():
	print("Room is full, you are being disconnected.")
	get_tree().change_scene_to_packed(modechoice_scene)

@rpc("any_peer", "call_local")
func start_battle():
	show_countdown_ui(3)
	hide_countdown_ui()
	
	
@rpc("any_peer")
func receive_enemy_element(element: String) -> void:
	Global.enemy_element = element
	if is_instance_valid(battle_UI_scene):
		battle_UI_scene.init_enemy_ui()
	
		if Global.enemy_mana_component:
			element = Global.enemy_element
			var mana = Global.enemy_mana_component.current_mana.get(element, 0)
			battle_UI_scene.update_enemy_mana(Global.enemy_mana_component.current_mana)

@rpc("any_peer")
func send_selected_element_to_host(element: String) -> void:
	Global.enemy_element = element
	print("Host received client's element:", element)

	if is_instance_valid(battle_UI_scene):
		battle_UI_scene.init_enemy_ui()
		if Global.enemy_mana_component:
			var mana = Global.enemy_mana_component.current_mana.get(element, 0)
			battle_UI_scene.update_enemy_mana(Global.enemy_mana_component.current_mana)
