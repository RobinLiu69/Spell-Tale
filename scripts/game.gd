class_name Game
extends Node2D

@export var player_scene: PackedScene
@onready var esc_menu: Control = $UI/EscMenu
@onready var multiplayer_scene = preload("res://scenes/ui/multiplayer.tscn")
@onready var modechoice_scene = preload("res://scenes/ui/modechoice.tscn")
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
		$UI.add_child(multiplayer_screen)
		$MultiplayerSpawner.spawn_function = add_player
		setup_menu_player_reference()
	else:
		peer.create_server(randi_range(1,9999))
		multiplayer.multiplayer_peer = peer
		get_tree().get_multiplayer().peer_disconnected.connect(_on_peer_disconnected)
		$MultiplayerSpawner.spawn_function = add_player
		$MultiplayerSpawner.spawn(multiplayer.get_unique_id())
		Global.multiplayer_ui_status = false

func setup_menu_player_reference():
	esc_menu.player = $Player
	$Player/MultiplayerSynchronizer.queue_free()
	$Player/HealthBar/MultiplayerSynchronizer.queue_free()

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

func _process(delta: float) -> void:
	pass

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
		rpc("start_countdown")

func _on_peer_disconnected(pid):
	print("delete player")
	del_player(pid)

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
	if player.has_node("ManaComponent"):
		var mc = player.get_node("ManaComponent")
		if pid == multiplayer.get_unique_id():
			Global.player_mana_component = mc
		else:
			Global.enemy_mana_component = mc
			
			if player.has_method("get_selected_element"):
				Global.enemy_element = player.get_selected_element()
			elif "selected_element" in player:
				Global.enemy_element = player.selected_element
			else:
				Global.enemy_element = "fire"  # fallback 預設值
	return player

func show_countdown_ui(duration: int):
	count_down_display.visible = true
	for i in range(duration, 0, -1):
		count_down_label.text = "Battle starts in " + str(i) + " Second"
		await get_tree().create_timer(1).timeout
	count_down_label.text = "Battle Starts!"

func hide_countdown_ui():
	await get_tree().create_timer(3).timeout
	count_down_display.visible = false

func del_player(pid):
	rpc("_del_player", pid)

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
func start_countdown():
	for player in players:
		player.can_move = false
		player.can_cast = false

	show_countdown_ui(5)
	await get_tree().create_timer(5).timeout

	for player in players:
		player.can_move = true
		player.can_cast = true

	if is_instance_valid(battle_UI_scene):
		battle_UI_scene.visible = true
		battle_UI_scene.local_player = local_player
		battle_UI_scene.remote_player = players.filter(func(p): return p != local_player)[0]
		battle_UI_scene.assign_player_roles()
		
		battle_UI_scene.init_player_ui()
		battle_UI_scene.init_enemy_ui()
		battle_UI_scene.connect_health_signals()
		battle_UI_scene.connect_mana_signals()

		hide_countdown_ui()
