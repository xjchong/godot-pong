class_name Game
extends Node2D


export var is_against_ai: bool = true

var screen_size: Vector2
var is_game_running: bool = false
var is_game_ready: bool = false
var _ai_dest_pos: Vector2
var _ai_start_pos: Vector2

onready var ball: Ball = $Ball
onready var screen_shake: ScreenShake = $Camera2D/ScreenShake
onready var impact_timer: Timer = $ImpactTimer
onready var p1_paddle: Paddle = $Player1Paddle
onready var p2_paddle: Paddle = $Player2Paddle
onready var score_board: ScoreBoard = $CanvasLayer/ScoreBoard
onready var p1_ready: Ready = $Player1Ready
onready var p2_ready: Ready = $Player2Ready
onready var win_screen: WinScreen = $WinScreen
onready var hints_overlay: HintsOverlay = $HintsOverlay

var ai := AI.new()


func _ready() -> void:
	screen_size = get_viewport_rect().size
	set_process(true)
	
	yield(ball, "reset_finished")
	
	is_against_ai = GameSetting.is_against_ai
	if is_against_ai:
		var personalities = [
			"lazy", "spinny", "spikey", "normy", "boss"
		]
		var personality = personalities[randi() % personalities.size()]

		ai.setup(p2_paddle, "spinny")
		_reset_ai()
		
	is_game_ready = true

	
func _process(_delta):	
	if (not is_game_running and is_game_ready
			and p1_ready.is_ready and p2_ready.is_ready):
		_start_round()
		
	if Input.is_action_pressed("player_1_up"):
		p1_paddle.move_up()
	elif Input.is_action_pressed("player_1_down"):
		p1_paddle.move_down()
	
	if is_against_ai and is_game_ready and is_game_running:
#		p1_ai.handle(ball)
		ai.handle(ball)
	elif !is_against_ai:
		if Input.is_action_pressed("player_2_up"):
			p2_paddle.move_up()
		elif Input.is_action_pressed("player_2_down"):
			p2_paddle.move_down()
	
	
func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		$PauseScreen.open()
		
	if is_game_running:
		return

	if event.is_action_released("player_1_ready"):
		p1_ready.toggle()
	elif event.is_action_released("player_2_ready") and not is_against_ai:
		p2_ready.toggle()
		
		
func _on_Ball_collision(impact_percent):
	if impact_percent > 0.50:
		if SettingsManager.load_setting("screen_shake", "is_enabled", true):	
			var max_impact_delay = 0.08
			var max_duration = 0.2
			var max_frequency = 24
			var max_amplitude = 8
	
			impact_timer.start(max_impact_delay * impact_percent)
			get_tree().paused = true
	
			screen_shake.start(
				max_duration,
				max_frequency,
				max_amplitude * impact_percent)
		else:
			AudioManager.play(Audio.PADDLE_BOUNCE_HIGH)
	else:
		AudioManager.play(Audio.PADDLE_BOUNCE)
	

func _on_Goal_goal_scored(player_id):
	score_board.score(player_id)

	_new_game()
	

func _on_ScoreBoard_new_game():
	AudioManager.play(Audio.GAME_WIN)
	
	
func _on_ScoreBoard_match_won(player_id: int):
	get_tree().paused = true
	win_screen.show(player_id)
	

func _on_ScoreBoard_match_drawn():
	get_tree().paused = true
	win_screen.show(null)
	
	
func _start_round():
	p1_ready.confirm()
	p2_ready.confirm()
	is_game_running = true
	ball.start()
	hints_overlay.hide()
	AudioManager.play(Audio.GAME_START)


func _new_game():
	p1_paddle.reset()
	p2_paddle.reset()
	ball.reset()
	hints_overlay.show()
	
	is_game_running = false
	is_game_ready = false
	yield(ball, "reset_finished")
	is_game_ready = true
	
	if is_against_ai:
		_reset_ai()


func _reset_ai():
	p2_ready.toggle()
	ai.reset()


func _on_ImpactTimer_timeout():
	get_tree().paused = false
	AudioManager.play(Audio.PADDLE_BOUNCE_HIGH)
