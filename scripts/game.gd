class_name Game
extends Node2D

@export var player_scene: PackedScene
@onready var multiplayer_ui = $UI/Multiplayer
@onready var esc_menu: PanelContainer = $UI/ESCMenu



var peer = ENetMultiplayerPeer.new()

var players: Array[Player] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Global.is_multiplayer_mode:
		$MultiplayerSpawner.spawn_function = add_player
	else:
		var player = add_player(1)
		add_child(player)
		multiplayer_ui.hide()

func _input(event) -> void: 
	if event.is_action_pressed("ui_cancel"):  
		toggle_pause_menu()
		
func toggle_pause_menu():
	esc_menu.visible = ! Global.menu_status
	if Global.multiplayer_ui_status:
		multiplayer_ui.visible = Global.menu_status
	Global.menu_status = ! Global.menu_status
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func _on_host_pressed() -> void:
	peer.create_server(25565)
	multiplayer.multiplayer_peer = peer
	$MultiplayerSpawner.spawn_function = add_player
	
	multiplayer.peer_connected.connect(
		func(pid):
			print("peer " + str(pid) + " joined")
			$MultiplayerSpawner.spawn(pid)
	)
	
	$MultiplayerSpawner.spawn(multiplayer.get_unique_id())
	multiplayer_ui.hide()
	Global.multiplayer_ui_status = false


func _on_join_pressed() -> void:
	peer.create_client("localhost", 25565)
	multiplayer.multiplayer_peer = peer
	multiplayer_ui.hide()
	Global.multiplayer_ui_status = false


func add_player(pid) -> Node2D:
	var player: Player = player_scene.instantiate()
	player.name = str(pid)
	player.global_position = $Level.get_child(players.size()).global_position
	player.is_multiplayer_mode = Global.is_multiplayer_mode
	players.append(player)
	
	
	return player
