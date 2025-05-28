class_name Game
extends Node2D

@export var player_scene: PackedScene
@onready var multiplayer_ui = $UI/Multiplayer

var peer = ENetMultiplayerPeer.new()

var players: Array[Player] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MultiplayerSpawner.spawn_function = add_player


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


func _on_join_pressed() -> void:
	peer.create_client("localhost", 25565)
	multiplayer.multiplayer_peer = peer
	multiplayer_ui.hide()


func add_player(pid) -> Node2D:
	var player: Player = player_scene.instantiate()
	
	player.name = str(pid)
	player.global_position = $Level.get_child(players.size()).global_position
	players.append(player)
	
	
	return player
