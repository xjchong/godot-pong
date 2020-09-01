class_name Ball
extends KinematicBody2D


signal reset_finished()

const DEFAULT_VELOCITY: float = 400.0
const MAX_VELOCITY: float = 2000.0

# Horizontal veocity addition on bouncing off a paddle.
const ACCELERATION_CONSTANT: float = 15.0

# Torque multiplier after colliding with a surface.
const SURFACE_FRICTION: float = 0.7

const MAX_TORQUE: float = 30.0
# Velocity on collision is increased by at most this percentage at max torque.
const MAX_TORQUE_TRANSFER: float = 1.5
const MAX_TORQUE_VELOCITY: float = 60.0
const TORQUE_GROWTH_CONSTANT: float = 5.0

export var player_id: int
export var default_position: Vector2 = Vector2(400, 250)

var _torque: float = 0.0
var _base_velocity: Vector2 = Vector2()
var velocity: Vector2 = Vector2()

onready var motion_trail: Trail2D = $MotionTrail
onready var paddle_bounce_audio: AudioStreamPlayer = $PaddleBounceAudio
onready var wall_bounce_audio: AudioStreamPlayer = $WallBounceAudio
onready var reset_animation: AnimationPlayer = $ResetAnimation

	
func _ready():
	randomize()
	reset()


func start():
	velocity.x = DEFAULT_VELOCITY if randi() % 2 == 0 else -DEFAULT_VELOCITY
	_base_velocity.x = -velocity.x
	

func reset(): 
	position = default_position
	rotation_degrees = 0.0
	motion_trail.trail_points.clear()
	velocity = Vector2()
	_base_velocity = Vector2()
	_torque = 0.0

	reset_animation.play("Reset")
	yield(reset_animation, "animation_finished")
	emit_signal("reset_finished")
	

func _physics_process(delta):
	var collision: KinematicCollision2D = move_and_collide(velocity * delta)

	_apply_torque()
	
	if collision == null:
		return
		
	var collider = collision.get_collider()

	if collider.is_in_group("paddle"):
		_handle_paddle_collision(collider)
	elif collider.is_in_group("wall"):
		_handle_wall_collision()


func _apply_torque():
	var rotation = _torque / MAX_TORQUE * 50
	var torque_percent = (
			(pow(TORQUE_GROWTH_CONSTANT, abs(_torque / MAX_TORQUE)) - 1) 
			/ (TORQUE_GROWTH_CONSTANT - 1))
			
	var torque_velocity = torque_percent * MAX_TORQUE_VELOCITY
	
	if _torque < 0:
		torque_velocity *= -1.0
		
	if velocity.x > 0:
		velocity.y += torque_velocity
	else:
		velocity.y -= torque_velocity

	rotation_degrees = rotation_degrees + rotation
	
	
func _handle_paddle_collision(paddle: Paddle):
	if _base_velocity.x < 0:
		_base_velocity.x -= ACCELERATION_CONSTANT
	else:
		_base_velocity.x += ACCELERATION_CONSTANT
		
	_base_velocity.y = velocity.y
	_base_velocity.x *= -1
	_base_velocity.x = clamp(_base_velocity.x, -MAX_VELOCITY, MAX_VELOCITY)
	
	var next_torque = paddle.get_torque(position, _base_velocity, _torque)
	var next_velocity = paddle.get_velocity(position, _base_velocity, _torque)
	
	next_velocity.x = clamp(next_velocity.x, -MAX_VELOCITY, MAX_VELOCITY)
	
	velocity = next_velocity
	_torque = next_torque
	
	if !paddle_bounce_audio.playing: 
		paddle_bounce_audio.play()

func _handle_wall_collision():
	var is_topspin = (
		velocity.x > 0 and velocity.y < 0 and _torque < 0 or
		velocity.x > 0 and velocity.y > 0 and _torque > 0 or
		velocity.x < 0 and velocity.y < 0 and _torque > 0 or
		velocity.x < 0 and velocity.y > 0 and _torque < 0)
		
	if is_topspin:
		var transfer = (abs(_torque) / MAX_TORQUE) * MAX_TORQUE_TRANSFER
		
		velocity.x *= (1.0 + transfer)
		
	velocity.y *= -SURFACE_FRICTION
		
	_torque = lerp(_torque, 0.0, SURFACE_FRICTION)
	wall_bounce_audio.play()
	
