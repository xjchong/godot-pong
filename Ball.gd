class_name Ball
extends KinematicBody2D


const DEFAULT_VELOCITY: float = 400.0
const MAX_VELOCITY: float = 2000.0

# Horizontal veocity multiplier on bouncing off a paddle.
const ACCELERATION: float = 1.05

# Vertical velocity multiplier on bouncing off a wall.
const DECCELERATION: float = 0.8 

# Torque multipler after colliding with a surface.
const SURFACE_FRICTION: float = 0.5

const MAX_TORQUE: float = 15.0

const MAX_TORQUE_VELOCITY: float = 15.0

# Vertical velocity multiplier when hitting paddle edge.
const PADDLE_TENSION: float = 3.5

# Horizontal velocity multiplier when countering vertical velocity.
const PADDLE_COUNTER_ACCELERATION: float = 2.3

export var player_id: int
export var default_position: Vector2 = Vector2(400, 250)

# This starts at default velocity at the start of a round
#  and increases as the round goes on.
var base_velocity_x: float = DEFAULT_VELOCITY

var _torque: float = 0.0

onready var motion_trail: Trail2D = $MotionTrail
onready var paddle_bounce_audio: AudioStreamPlayer = $PaddleBounceAudio
onready var wall_bounce_audio: AudioStreamPlayer = $WallBounceAudio

var velocity: Vector2 = Vector2()


func _init():
	randomize()


func start():
	velocity.x = DEFAULT_VELOCITY if randi() % 2 == 0 else -DEFAULT_VELOCITY


func reset(): 
	motion_trail.trail_points.clear()
	velocity = Vector2(0, 0)
	position = default_position
	base_velocity_x = DEFAULT_VELOCITY
	_torque = 0.0
	rotation_degrees = 0.0


func _physics_process(delta):
	var collision: KinematicCollision2D = move_and_collide(velocity * delta)
	
	_apply_rotation(_torque)
	
	if collision == null:
		var torque_velocity = (_torque / MAX_TORQUE) * MAX_TORQUE_VELOCITY
		
		if velocity.x > 0:
			velocity.y += torque_velocity
		else:
			velocity.y -= torque_velocity
			
		return
		
	var collider = collision.get_collider()
	
	_torque = lerp(_torque, 0.0, SURFACE_FRICTION)

	if collider.is_in_group("paddle"):
		var paddle: Paddle = collider
		var next_velocity_y = velocity.y + (position.y - paddle.position.y) * PADDLE_TENSION
		var magnitude_y_delta = abs(next_velocity_y) - abs(velocity.y)
		var paddle_torque = paddle.torque if base_velocity_x > 0 else \
				-paddle.torque
		
		base_velocity_x = -base_velocity_x * ACCELERATION
		_torque = clamp(_torque + paddle_torque, -MAX_TORQUE, MAX_TORQUE)

		print("paddle torque: %s, ball torque: %s" % [paddle_torque, _torque])
		
		# Clamp the velocity to reasonable max, otherwise weird things can happen.
		if base_velocity_x < 0:
			base_velocity_x = max(base_velocity_x, -MAX_VELOCITY)
		else:
			base_velocity_x = min(base_velocity_x, MAX_VELOCITY)
		
		# If the vertical velocity of the ball is 'countered', then the
		#  horizontal velocity is given a temporary boost depending on how
		#  much vertical velocity was absorbed.
		if magnitude_y_delta > 0:
			velocity.x = base_velocity_x
		elif base_velocity_x < 0:
			velocity.x = base_velocity_x + (magnitude_y_delta * PADDLE_COUNTER_ACCELERATION)
		else:
			velocity.x = base_velocity_x - (magnitude_y_delta * PADDLE_COUNTER_ACCELERATION)

		velocity.y = next_velocity_y
		
		if !paddle_bounce_audio.playing: 
			paddle_bounce_audio.play()
	elif collider.is_in_group("wall"):
		velocity.y = -velocity.y * DECCELERATION
		wall_bounce_audio.play()

func _apply_rotation(torque: float):
	var rotation = torque / MAX_TORQUE * 30

	rotation_degrees = rotation_degrees + rotation
