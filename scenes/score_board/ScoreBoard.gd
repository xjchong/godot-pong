class_name ScoreBoard
extends VBoxContainer


const DEFAULT_DEUCE_MARGIN = 2

signal new_game()
signal match_won(player_id)
signal match_drawn()

var game_points = 10
var match_games = 2
var is_deuce_enabled: bool
var deuce_margin = DEFAULT_DEUCE_MARGIN

var p1_game_score: int = 0
var p2_game_score: int = 0
var p1_match_score: int = 0
var p2_match_score: int = 0

onready var game_points_label: Label = $GamePointsLabel
onready var match_games_label: Label = $MatchGamesLabel
onready var p1_game_score_label: Label = $HBoxContainer/HBoxContainer/Player1GameScore
onready var p1_match_score_label: Label = $HBoxContainer/HBoxContainer/Player1MatchScore
onready var p2_game_score_label: Label = $HBoxContainer/HBoxContainer2/Player2GameScore
onready var p2_match_score_label: Label = $HBoxContainer/HBoxContainer2/Player2MatchScore


func _ready():
	var section = "1p_match" if GameSetting.is_against_ai else "2p_match"
	
	game_points = SettingsManager.load_setting(section, "game_points", 11)
	match_games = SettingsManager.load_setting(section, "match_games", 3)
	is_deuce_enabled = SettingsManager.load_setting(section, "is_deuce_enabled", true)
	
	if not is_deuce_enabled:
		deuce_margin = 0
	
	_update_labels()


func _update_labels():
	game_points_label.text = "%d point game" % game_points
	match_games_label.text = "Best of %d" % match_games
	p1_game_score_label.text = String(p1_game_score)
	p2_game_score_label.text = String(p2_game_score)
	p1_match_score_label.text = String(p1_match_score)
	p2_match_score_label.text = String(p2_match_score)
	
	
func score(player_id: int):
	match player_id:
		1:
			p2_game_score += 1
		2:
			p1_game_score += 1
	
	_update_all_scores()
			

func _update_all_scores():
	var p1_game_score_margin = p1_game_score - p2_game_score
	var p2_game_score_margin = p2_game_score - p1_game_score
	
	if p1_game_score >= game_points \
			and p1_game_score_margin >= deuce_margin:
		p1_match_score += 1
		_end_game()
	elif p2_game_score >= game_points \
			and p2_game_score_margin >= deuce_margin:
		p2_match_score += 1
		_end_game()
		
	_update_labels()
		
	
func _end_game():
	p1_game_score = 0
	p2_game_score = 0
	
	if p1_match_score > match_games / 2:
		emit_signal("match_won", 1)
	elif p2_match_score > match_games / 2:
		emit_signal("match_won", 2)
	elif p1_match_score + p2_match_score == match_games:
		emit_signal("match_drawn")
	else:
		emit_signal("new_game")
	
