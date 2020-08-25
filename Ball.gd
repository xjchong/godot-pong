class_name Ball
extends KinematicBody2D


const DEFAULT_VELOCITY: float = 400.0
const MAX_VELOCITY: float = 2000.0
const ACCELERATION: float = 1.05
const DECCELERATION: float = 0.2

export var player_id: int
export var default_position: Vector2 = Vector2(400, 250)

# This starts at default velocity at the start of a round
#  and increases as the round goes on.
var base_velocity_x: float = DEFAULT_VELOCITY

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


func _physics_process(delta):
	var collision: KinematicCollision2D = move_and_collide(velocity * delta)
	
	if collision == null:
		return
		
	var collider = collision.get_collider()

	if collider.is_in_group("paddle"):
		var paddle: Paddle = collider
		var next_velocity_y = velocity.y + ((position.y - collider.position.y) \
			* abs(paddle.velocity.y))
		var magnitude_y_delta = abs(next_velocity_y) - abs(velocity.y)
		
		base_velocity_x = -base_velocity_x * ACCELERATION
		
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
			velocity.x = base_velocity_x + magnitude_y_delta
		else:
			velocity.x = base_velocity_x - magnitude_y_delta

		velocity.y = next_velocity_y
		
		if !paddle_bounce_audio.playing: 
			paddle_bounce_audio.play()
		
	if collider.is_in_group("wall"):
		velocity.y = -velocity.y
		wall_bounce_audio.play()
