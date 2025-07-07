extends Node
var players := {}

func register_player(pid: int, player: Node):
	players[pid] = player

func get_player(pid: int) -> Node:
	return players.get(pid, null)

@rpc("any_peer", "call_local")
func announce_player(pid: int, path: NodePath):
	var player = get_node_or_null(path)
	if player:
		register_player(pid, player)
