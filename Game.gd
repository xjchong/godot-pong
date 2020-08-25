class_name Game
extends Node2D


var screen_size: Vector2
var is_game_running: bool = false

onready var ball: Ball = $Ball
onready var p1_paddle: Paddle = $Player1Paddle
onready var p2_paddle: Paddle = $Player2Paddle
onready var p1_score: Score = $Player1Score
onready var p2_score: Score = $Player2Score
onready var p1_ready: Ready = $Player1Ready
onready var p2_ready: Ready = $Player2Ready
onready var start_audio: AudioStreamPlayer = $StartAudio


func _ready() -> void:
	screen_size = get_viewport_rect().size
	set_process(true)
	
	
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
	match player_id:
		1:
			p2_score.increment()
		2:
			p1_score.increment()
			
	_restart()
	
	
func _start_round():
	p1_ready.confirm()
	p2_ready.confirm()
	is_game_running = true
	ball.start()
	start_audio.play()


func _restart():
	ball.reset()
	p1_paddle.reset()
	p2_paddle.reset()
	is_game_running = false
	
