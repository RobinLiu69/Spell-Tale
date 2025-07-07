extends Node

var players := {}

func register_player(pid: int, player: Node):
	players[pid] = player

func get_player(pid: int) -> Node:
	return players.get(pid, null)
