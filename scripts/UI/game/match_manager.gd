extends Node

var match_winner := ""  
var result_ui: ResultUI

const WIN_SCORE := 2

var game_scene_ref

@rpc("any_peer")
func _on_player_died(dead_player_pid: int):	
	if not multiplayer.is_server(): 
		return 
	
	var winner_pid:int = find_opponent_pid(dead_player_pid)
	
	if dead_player_pid == 1:
		Global.player_2_score += 1
	else:
		Global.player_1_score += 1
	
	print("winner: ", winner_pid," loser: ", dead_player_pid)
	rpc("sync_scores", Global.player_1_score, Global.player_2_score)
	rpc("sync_round_result", winner_pid, dead_player_pid)
	
@rpc("call_local")
func sync_round_result(winner_pid: int, loser_pid: int):
	if result_ui:
		result_ui.show_death_ui(loser_pid)
		result_ui.show_win_ui(winner_pid)
		await get_tree().create_timer(3).timeout
		result_ui.update_score_display(Global.player_1_score, Global.player_2_score)
		print("P1 score: ",Global.player_1_score," P2 score: ",Global.player_2_score)

		if Global.player_1_score == WIN_SCORE or Global.player_2_score == WIN_SCORE:
			if winner_pid == 1:
				result_ui.show_match_result_ui("player 1")
			else:
				result_ui.show_match_result_ui("player 2")
		else:
			result_ui.start_next_round()
			
@rpc("call_local")
func sync_scores(p1_score: int, p2_score: int):
	Global.player_1_score = p1_score
	Global.player_2_score = p2_score

func reset_match():
	Global.player_1_score = 0
	Global.player_2_score = 0
	match_winner = ""
	Global.revealed_spell_ids.clear()
	
	
	
func find_opponent_pid(pid: int) -> int:
	for peer in multiplayer.get_peers():
		if peer != pid:
			return peer
	
	return 1 if pid != 1 else -1
