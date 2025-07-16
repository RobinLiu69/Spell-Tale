extends Control
class_name ResultUI

var game_scene_ref
var player: Player
var has_requested_rematch: bool = false
var has_received_rematch_request: bool = false
var auto_rematch_on_rejoin: bool = false



func _ready() -> void:
	MatchManager.result_ui = self
	$MatchResultPanel/VBoxContainer/HBoxContainer/RematchAction.action = Callable(self,"_on_RematchButton_pressed")
	$MatchResultPanel/VBoxContainer/HBoxContainer/QuitAction.action = Callable(self,"_on_ExitRoomButton_pressed")
	
	
func show_death_ui(dead_player_pid: int):
	if multiplayer.get_unique_id() == dead_player_pid:
		print("show death ui, dead player: ", dead_player_pid)
		$DeathPanel.visible = true
		await  get_tree().create_timer(3).timeout
		$DeathPanel.visible = false

func show_win_ui(winner_pid: int):
	if multiplayer.get_unique_id() == winner_pid:
		print("show win ui, winner is: ", winner_pid)
		$WinPanel.visible = true
		await  get_tree().create_timer(3).timeout
		$WinPanel.visible = false

func update_score_display(p1_score: int, p2_score: int):
	$ScoreDisplay/HBoxContainer/Player1ScoreLabel.text = "Client: %s" % str(p2_score)
	$ScoreDisplay/HBoxContainer/Player2ScoreLabel.text = "Host: %s" % str(p1_score)

func show_match_result_ui(winner: String):
	$MatchResultPanel.visible = true
	$MatchResultPanel/VBoxContainer/ResultLabel.text = "The Winner is ：" + winner

func show_client_exit_result(winner: String):
	$MatchResultPanel.visible = true
	$MatchResultPanel/VBoxContainer/ResultLabel.text = "Client exit, you are the winner!"
	auto_rematch_on_rejoin = true
	
	

func start_next_round():
	game_scene_ref.reset_game_state()
	game_scene_ref.show_countdown_ui(3)
	await game_scene_ref.hide_countdown_ui()

func is_local_player(player_pid: int) -> bool:
	return multiplayer.get_unique_id() == player_pid

func _on_RematchButton_pressed() -> void:
	if has_requested_rematch:
		print("Rematch already requested, ignoring click")
		return
	
	if multiplayer.is_server() and auto_rematch_on_rejoin:
		print("success")
		$".".visible = false
		MatchManager.reset_match()
		game_scene_ref.reset_game_state()
		return
		

	has_requested_rematch = true

	if has_received_rematch_request:
		if multiplayer.is_server():
			rpc("start_rematch_for_both") 
		else:
			rpc_id(1, "start_rematch_for_both") 
	else:
		print("waiting for Rematch")
		$MatchResultPanel/VBoxContainer/ResultLabel.text = "waiting for Rematch..."
		rpc("receive_rematch_request")


func _on_ExitRoomButton_pressed() -> void:
	MatchManager.reset_match()
	game_scene_ref.exit_game()
	get_tree().change_scene_to_file("res://scenes/ui/modechoice.tscn")
	
@rpc("any_peer")
func receive_rematch_request():
	has_received_rematch_request = true
	print("received Rematch request")
	$MatchResultPanel/VBoxContainer/ResultLabel.text = "opponent requests rematch, press rematch to start a new fight!"

@rpc("any_peer", "call_local")
func start_rematch_for_both():
	if $MatchResultPanel.visible:
		$MatchResultPanel.visible = false
	rpc("reset_rematch_flags")
	print("successfully rematch, start a new game")
	$MatchResultPanel.visible = false
	MatchManager.reset_match()
	game_scene_ref.reset_game_state()
	update_score_display(Global.player_1_score,Global.player_2_score)
	game_scene_ref.show_countdown_ui(3)
	await game_scene_ref.hide_countdown_ui()
	
	
@rpc("any_peer", "call_local")
func reset_rematch_flags():
	print("Resetting rematch flags")
	has_requested_rematch = false
	has_received_rematch_request = false
	MatchManager.reset_match()
	game_scene_ref.reset_game_state()
	update_score_display(Global.player_1_score,Global.player_2_score)
	if is_instance_valid($MatchResultPanel):
		$MatchResultPanel.visible = false
