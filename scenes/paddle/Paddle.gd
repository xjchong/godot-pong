class_name Paddle
extends KinematicBody2D


const MAX_VELOCITY: float = 15.0
const MAX_TORQUE: float = 15.0
const ACCELERATION: float = 0.15
const DECCELERATION: float = 0.2
const BLADE_LENGTH: float = 112.0 # Should equal paddle height in pixels.
const BLADE_CONTROL_DECAY: float = 2.0 # Higher control has less vertical velocity variance.
const BLADE_CONTROL_MAX_VARIANCE: float = 500.0 # Maximum vertical velocity applied.

export var player_id: int
export var default_position: Vector2

var velocity: Vector2 = Vector2()
var blade_tension: float = 0.8 # Horizontal hit velocity multipler on counter.
var torque_growth: float = 0.1
var torque_decay: float = 0.7
var torque: float = 0.0
var _did_move: bool = false

	
func _physics_process(_delta):	
	if _did_move:
		_did_move = false
	else:
		velocity.y = lerp(velocity.y, 0, DECCELERATION)
		torque = lerp(torque, 0.0, torque_decay)
		
	var collision: KinematicCollision2D = move_and_collide(velocity)
	
	if collision == null:
		return
	
	# Paddle hit the wall, torque is cancelled completely.	
	if collision.get_collider().is_in_group("wall"):
		torque = 0.0
	
	
func move_up():
	velocity.y = lerp(velocity.y, -MAX_VELOCITY, ACCELERATION)
	torque = lerp(torque, -MAX_TORQUE, torque_growth)
	_did_move = true
	

func move_down():
	velocity.y = lerp(velocity.y, MAX_VELOCITY, ACCELERATION)
	torque = lerp(torque, MAX_TORQUE, torque_growth)
	_did_move = true
	
	
func get_velocity(hit_position: Vector2, hit_velocity: Vector2, _hit_torque: float) -> Vector2:
	var next_velocity: Vector2 = hit_velocity
	
	# Reverse the x velocity.
	next_velocity.x *= -1.0
	
	# Calculate the vertical velocity applied.
	var max_hit_position_delta = BLADE_LENGTH / 2
	var hit_delta_percent = (hit_position.y - position.y) / max_hit_position_delta
	var variance_percent = (
			(pow(BLADE_CONTROL_DECAY, abs(hit_delta_percent)) - 1)
			/ (BLADE_CONTROL_DECAY - 1)
	)
	
	var variance = variance_percent * BLADE_CONTROL_MAX_VARIANCE
	
	if hit_delta_percent < 0:
		variance *= -1
		
	next_velocity.y += variance
	
	# Calculate counter boost to horizontal velocity.
	var magnitude_y_delta = abs(next_velocity.y) - abs(hit_velocity.y)
	var remaining_force = (abs(hit_velocity.y) - magnitude_y_delta) * blade_tension

	if remaining_force > 0:
		if next_velocity.x < 0:
			next_velocity.x -= remaining_force
		else:
			next_velocity.x += remaining_force
		
	return next_velocity
	

func get_torque(_hit_position: Vector2, hit_velocity: Vector2, hit_torque: float) -> float:
	var reduced_hit_torque = lerp(hit_torque, 0.0, 0.5)
	var applied_torque = torque if hit_velocity.x > 0 else -torque
	
	return reduced_hit_torque + applied_torque
	
	
func reset():
	velocity = Vector2()
	position = default_position
