extends Node


var _ai_dest_pos := Vector2()


func reset(paddle: Paddle):
	_ai_dest_pos = paddle.position


func handle(ball: Ball, paddle: Paddle):
	var allowable_distance = 20.0
	var current_pos = paddle.position
	var min_pos_y = 80.0
	var max_pos_y = 420.0
	var boredom_chance = 0.08 # Chance of getting distracted.
	var sleep_chance = 0.5 # Chance of not tracking the ball. 
	var spike_desire = 0.0
	var has_reached_dest = (
		abs(abs(current_pos.y) - abs(_ai_dest_pos.y)) < allowable_distance
	)
	
	if has_reached_dest:
		var _ai_start_pos = current_pos
		_ai_dest_pos.x = current_pos.x
			
		# Set a new destination
		if ball.velocity.x < 0 and rand_range(0, 1) < boredom_chance: 
			_ai_dest_pos.y = rand_range(min_pos_y, max_pos_y)
		elif ball.velocity.x < 0 and rand_range(0, 1) > sleep_chance:
			_ai_dest_pos.y = clamp(ball.position.y, min_pos_y, max_pos_y)
		elif ball.velocity.x > 0:
			var next_y = ball.position.y
			
			if rand_range(0, 1) < spike_desire:
				var blade_offset = paddle.BLADE_LENGTH / 2.5
				
				next_y += rand_range(-blade_offset, blade_offset)
				
				if ball.velocity.y > 0:
					next_y = ball.position.y + blade_offset
				elif ball.velocity.y < 0:
					next_y = ball.position.y - blade_offset
				
			_ai_dest_pos.y = clamp(next_y, min_pos_y, max_pos_y)
	else:
		if _ai_dest_pos.y > current_pos.y:
			paddle.move_down()
		elif _ai_dest_pos.y < current_pos.y:
			paddle.move_up()
