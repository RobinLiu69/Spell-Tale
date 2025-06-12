class_name Game
extends Node2D

@export var player_scene: PackedScene
@onready var esc_menu: PanelContainer = $UI/ESCMenu
@onready var multiplayer_scene = preload("res://scenes/multiplayer.tscn")
@onready var modechoice_scene = preload("res://scenes/modechoice.tscn")
@onready var port_display: MarginContainer = $UI/PortDisplay
@onready var port: Label = $UI/PortDisplay/Port
@onready var port_in_game: Label = $UI/PortDisplayInGame/PortInGame
@onready var port_display_in_game: MarginContainer = $UI/PortDisplayInGame


var peer = ENetMultiplayerPeer.new()
var players: Array[Player] = []

func _ready() -> void:
	randomize()
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
	var esc_menu = $UI/ESCMenu
	var player = $Player
	esc_menu.player = player

func port_manifest() -> void:
	port_display.visible = true
	port.text = "Room has been successfully created, Port is: " + str(Global.server_port)
	port_in_game.text = "Room port is: " + str(Global.server_port)
	await get_tree().create_timer(5).timeout
	port_display.visible = false
	
	
	
func _input(event) -> void:
	if event.is_action_pressed("ui_cancel") && get_tree().current_scene.name == "Game":
		toggle_pause_menu()

func toggle_pause_menu():
	esc_menu.visible = ! Global.menu_status
	port_display_in_game.visible = ! Global.menu_status
	Global.menu_status = ! Global.menu_status
	

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
	rpc("notify_clients_game_ending")
	del_player(pid)
	await cleanup_multiplayer()
	for player in players:
		player.queue_free()
	
func cleanup_multiplayer():
	if multiplayer.multiplayer_peer:
		multiplayer.multiplayer_peer.close()
		multiplayer.multiplayer_peer = null
		
	var new_multiplayer := SceneMultiplayer.new()
	get_tree().set_multiplayer(new_multiplayer)

func _on_peer_connected(pid):
	print("peer " + str(pid) + " joined")
	$MultiplayerSpawner.spawn(pid)
	Global.achivement1_status = true

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
	var player: Player = player_scene.instantiate()
	player.name = str(pid)
	var spawn_index = (int(pid)-1) % $Level.get_child_count()
	player.global_position = $Level.get_child(spawn_index).global_position
	if pid == multiplayer.get_unique_id():
		$UI/ESCMenu.player = player
	players.append(player)
	return player

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
	cleanup_multiplayer()
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_packed(modechoice_scene)
