extends Control
class_name ResultUI

var game_scene_ref
var player: Player

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
	$ScoreDisplay/HBoxContainer/Player1ScoreLabel.text = "P1: %s" % str(p1_score)
	$ScoreDisplay/HBoxContainer/Player2ScoreLabel.text = "P2: %s" % str(p2_score)

func show_match_result_ui(winner: String):
	$MatchResultPanel.visible = true
	$MatchResultPanel/VBoxContainer/ResultLabel.text = "The Winner is ：" + winner

func start_next_round():
	game_scene_ref.reset_game_state()
	game_scene_ref.show_countdown_ui(3)
	await game_scene_ref.hide_countdown_ui()

func is_local_player(player_pid: int) -> bool:
	return multiplayer.get_unique_id() == player_pid

func _on_RematchButton_pressed() -> void:
	MatchManager.reset_match()
	game_scene_ref.reset_game_state()
	update_score_display(Global.player_1_score,Global.player_2_score)
	$MatchResultPanel.visible = false

func _on_ExitRoomButton_pressed() -> void:
	MatchManager.reset_match()
	game_scene_ref.exit_game(multiplayer.get_unique_id())
	get_tree().change_scene_to_file("res://scenes/ui/modechoice.tscn")	
