class_name Game
extends Node2D

@export var player_scene: PackedScene
@onready var esc_menu: PanelContainer = $UI/ESCMenu
@onready var multiplayer_scene = preload("res://scenes/multiplayer.tscn")



var peer = ENetMultiplayerPeer.new()

var players: Array[Player] = []

# Called when the node enters the scene tree for the first time.
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
		$MultiplayerSpawner.spawn_function = add_player
		$MultiplayerSpawner.spawn(multiplayer.get_unique_id())
		Global.multiplayer_ui_status = false

func setup_menu_player_reference():
	var esc_menu = $UI/ESCMenu
	var player = $Player  
	esc_menu.player = player


func _input(event) -> void: 
	if event.is_action_pressed("ui_cancel") && get_tree().current_scene.name == "Game":  
		toggle_pause_menu()
		
func toggle_pause_menu():
	esc_menu.visible = ! Global.menu_status
	Global.menu_status = ! Global.menu_status
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func host_room() -> void:
	peer.create_server(25565)
	multiplayer.multiplayer_peer = peer
	$MultiplayerSpawner.spawn_function = add_player
	multiplayer.peer_connected.connect(
		func(pid):
			print("peer " + str(pid) + " joined")
			$MultiplayerSpawner.spawn(pid)
			Global.achivement1_status = true
	)
	
	$MultiplayerSpawner.spawn(multiplayer.get_unique_id())
	Global.multiplayer_ui_status = false


func join_room() -> void:
	peer.create_client(str(Global.multiplayer_IP), 25565)
	multiplayer.multiplayer_peer = peer
	Global.multiplayer_ui_status = false
	Global.achivement1_status = true

func exit_game(pid):
	multiplayer.peer_disconnected.connect(del_player)
	del_player(pid)	


func add_player(pid) -> Node2D:
	var player: Player = player_scene.instantiate()
	player.name = str(pid)
	player.global_position = $Level.get_child(players.size()).global_position
	#players.append(player)
	if pid == multiplayer.get_unique_id():
		$UI/ESCMenu.player = player
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
		print("Player node", pid, "不存在或已被釋放")
	
	for i in range(players.size()):
		if players[i].multiplayer.get_unique_id() == int(pid):
			players[i].queue_free()
			players.pop_at(i)
			return
			
	if esc_menu.player and str(esc_menu.player.name) == str(pid):
		esc_menu.player = null
	
	
