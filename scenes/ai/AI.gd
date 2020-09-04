class_name AI
extends Node


const DEFAULT_MIN_POS_Y = 80.0
const DEFAULT_MAX_POS_Y = 420.0
const DEFAULT_ALLOWABLE_DISTANCE = 20.0
const DEFAULT_ALERT_DISTANCE = 700.0
const DEFAULT_BOREDOM_CHANCE = 0.08
const DEFAULT_SLEEP_CHANCE = 0.5
const DEFAULT_SPIKE_DESIRE = 0.0
const DEFAULT_SPIKE_OFFSET = 2.5
const DEFAULT_MODIFIED_PADDLE_ACCELERATION = 0.15
const DEFAULT_MODIFIED_TORQUE_GROWTH = 0.2
const DEFAULT_MODIFIED_TORQUE_DECAY = 0.05
const DEFAULT_MODIFIED_BLADE_TENSION = 0.8

export var min_pos_y = DEFAULT_MIN_POS_Y
export var max_pos_y = DEFAULT_MAX_POS_Y
export var allowable_distance = DEFAULT_ALLOWABLE_DISTANCE
export var alert_distance = DEFAULT_ALERT_DISTANCE
export var boredom_chance = DEFAULT_BOREDOM_CHANCE # Chance of getting distracted.
export var sleep_chance = DEFAULT_SLEEP_CHANCE # Chance of not tracking the ball.
export var spike_desire = DEFAULT_SPIKE_DESIRE # Chance of attempting to line up a spike.
export var spike_offset = DEFAULT_SPIKE_OFFSET # The offset attempted to hit the spike at.
export var modified_paddle_acceleration = DEFAULT_MODIFIED_PADDLE_ACCELERATION
export var modified_torque_growth = DEFAULT_MODIFIED_TORQUE_GROWTH
export var modified_torque_decay = DEFAULT_MODIFIED_TORQUE_DECAY
export var modified_blade_tension = DEFAULT_MODIFIED_BLADE_TENSION

var _ai_dest_pos := Vector2()
var paddle: Paddle = null


func setup(new_paddle: Paddle, setting: int):
	_setup_default_personality()
	
	match setting:
		1: 
			_setup_lazy_personality()
		2:
			_setup_normy_personality()
		3:
			_setup_spinny_personality()
		4:
			_setup_spikey_personality()
		5:
			_setup_boss_personality()
			
	paddle = new_paddle
	paddle.acceleration = modified_paddle_acceleration
	paddle.torque_growth = modified_torque_growth
	paddle.torque_decay = modified_torque_decay
	paddle.blade_tension = modified_blade_tension


func reset():
	_ai_dest_pos = paddle.position


func handle(ball: Ball):
	if paddle == null:
		return
		
	var current_pos = paddle.position
	var has_reached_dest = (
		abs(abs(current_pos.y) - abs(_ai_dest_pos.y)) < allowable_distance
	)
	
	if has_reached_dest:
		_set_new_dest(ball)
	else:
		if _ai_dest_pos.y > current_pos.y:
			paddle.move_down()
		elif _ai_dest_pos.y < current_pos.y:
			paddle.move_up()
			
			
func _set_new_dest(ball):
	var current_pos = paddle.position
	var _ai_start_pos = current_pos
	var is_ball_moving_closer = _is_ball_moving_closer(ball)
	_ai_dest_pos.x = current_pos.x
		
	# Set a new destination
	if not is_ball_moving_closer and _is_bored():
		_ai_dest_pos.y = rand_range(min_pos_y, max_pos_y)
	elif not is_ball_moving_closer and not _is_asleep():
		_ai_dest_pos.y = clamp(ball.position.y, min_pos_y, max_pos_y)
	elif is_ball_moving_closer and _is_in_alert_range(ball):
		var next_y = ball.position.y
		
		if rand_range(0, 1) < spike_desire:
			var blade_offset = paddle.BLADE_LENGTH / spike_offset
			
			next_y += rand_range(-blade_offset, blade_offset)
			
			if ball.velocity.y > 0:
				next_y = ball.position.y + blade_offset
			elif ball.velocity.y < 0:
				next_y = ball.position.y - blade_offset
			
		_ai_dest_pos.y = clamp(next_y, min_pos_y, max_pos_y)
		
			
func _is_ball_moving_closer(ball: Ball) -> bool:
	if ball.position.x < paddle.position.x and ball.velocity.x > 0:
		return true
	elif ball.position.x > paddle.position.x and ball.velocity.x < 0:
		return true
	else:
		return false
		

func _is_bored() -> bool:
	return rand_range(0, 1) < boredom_chance
	
	
func _is_asleep() -> bool:
	return rand_range(0, 1) < sleep_chance
	
	
func _is_in_alert_range(ball) -> bool:
	return abs(ball.position.x - paddle.position.x) <= alert_distance
	

func _setup_default_personality():
	min_pos_y = DEFAULT_MIN_POS_Y
	max_pos_y = DEFAULT_MAX_POS_Y
	allowable_distance = DEFAULT_ALLOWABLE_DISTANCE
	boredom_chance = DEFAULT_BOREDOM_CHANCE
	sleep_chance = DEFAULT_SLEEP_CHANCE
	spike_desire = DEFAULT_SPIKE_DESIRE
	modified_torque_growth = DEFAULT_MODIFIED_TORQUE_GROWTH
	modified_torque_decay = DEFAULT_MODIFIED_TORQUE_DECAY
	modified_blade_tension = DEFAULT_MODIFIED_BLADE_TENSION


func _setup_lazy_personality():
	allowable_distance = 30.0
	alert_distance = 600.0
	boredom_chance = 0.0
	sleep_chance = 0.9
	modified_paddle_acceleration = 0.13
	modified_torque_decay = 0.4
	modified_blade_tension = 0.7
	
	
func _setup_spinny_personality():
	allowable_distance = 10.0
	sleep_chance = 0.0
	modified_torque_growth = 0.9
	modified_blade_tension = 0.7
	
	
func _setup_spikey_personality():
	spike_desire = 1.0
	spike_offset = 2.2
	modified_torque_decay = 0.8
	modified_blade_tension = 1.2
	
	
func _setup_normy_personality():
	pass
	
	
func _setup_boss_personality():
	allowable_distance = 15.0
	boredom_chance = 0.05
	sleep_chance = 0.2
	spike_desire = 1.0
	modified_torque_growth = 0.6
	modified_blade_tension = 1.0
