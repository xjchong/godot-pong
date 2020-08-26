class_name Game
extends Node2D


const MIN_ROUND_SCORE: int = 21
const MIN_ROUND_MARGIN: int = 2

export var is_against_ai: bool

var screen_size: Vector2
var is_game_running: bool = false

onready var ball: Ball = $Ball
onready var p1_paddle: Paddle = $Player1Paddle
onready var p2_paddle: Paddle = $Player2Paddle
onready var score_board: ScoreBoard = $ScoreBoard
onready var p1_ready: Ready = $Player1Ready
onready var p2_ready: Ready = $Player2Ready
onready var start_audio: AudioStreamPlayer = $StartAudio
onready var game_win_audio: AudioStreamPlayer = $GameWinAudio


func _ready() -> void:
	screen_size = get_viewport_rect().size
	set_process(true)
	is_against_ai = GameSetting.is_against_ai
	
	if is_against_ai:
		p2_ready.toggle(false)
	
	
func _process(delta):
	if Input.is_action_pressed("player_1_up"):
		p1_paddle.move_up()
	elif Input.is_action_pressed("player_1_down"):
		p1_paddle.move_down()
	
	if is_against_ai:
		_handle_ai()
	else:
		if Input.is_action_pressed("player_2_up"):
			p2_paddle.move_up()
		elif Input.is_action_pressed("player_2_down"):
			p2_paddle.move_down()
	
	
func _unhandled_input(event):
	if is_game_running:
		return

	if event.is_action_released("player_1_ready"):
		p1_ready.toggle()
	elif event.is_action_released("player_2_ready"):
		p2_ready.toggle()
		
	if p1_ready.is_ready and p2_ready.is_ready:
		_start_round()
		

func _on_Goal_goal_scored(player_id):
	score_board.score(player_id)

	_new_game()
	

func _on_ScoreBoard_new_game():
	game_win_audio.play()
	
	
func _on_ScoreBoard_match_won(player_id: int):
	print(player_id)
	
	
func _start_round():
	p1_ready.confirm()
	p2_ready.confirm()
	is_game_running = true
	ball.start()
	start_audio.play()


func _new_game():
	ball.reset()
	p1_paddle.reset()
	p2_paddle.reset()
	is_game_running = false
	
	if is_against_ai:
		p2_ready.toggle(false)


func _handle_ai():
	if ball.position.y > p2_paddle.position.y:
		p2_paddle.move_down()
	elif ball.position.y < p2_paddle.position.y:
		p2_paddle.move_up()
