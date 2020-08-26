class_name ScoreBoard
extends Node2D


signal new_game
signal match_won(player_id)

const GAME_POINT_THRESHOLD = 20
const GAME_WIN_MARGIN = 2
const MATCH_POINT_THRESHOLD = 3

var p1_game_score: int = 0
var p2_game_score: int = 0
var p1_match_score: int = 0
var p2_match_score: int = 0

onready var p1_game_score_label: Label = $Player1GameScore
onready var p2_game_score_label: Label = $Player2GameScore
onready var p1_match_score_label: Label = $Player1MatchScore
onready var p2_match_score_label: Label = $Player2MatchScore


func _ready():
	_update_labels()


func _update_labels():
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
	
	if p1_game_score > GAME_POINT_THRESHOLD \
			and p1_game_score_margin >= GAME_WIN_MARGIN:
		p1_match_score += 1
		_end_game()
	elif p2_game_score > GAME_POINT_THRESHOLD \
			and p2_game_score_margin >= GAME_WIN_MARGIN:
		p2_match_score += 1
		_end_game()
		
	_update_labels()
		
	
func _end_game():
	p1_game_score = 0
	p2_game_score = 0
	
	if p1_match_score > MATCH_POINT_THRESHOLD	 \
			or p2_match_score > MATCH_POINT_THRESHOLD:
		emit_signal("match_won")
	else:
		emit_signal("new_game")
	
