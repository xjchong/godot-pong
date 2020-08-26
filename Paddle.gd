class_name Paddle
extends KinematicBody2D


const MAX_VELOCITY: float = 15.0
const MAX_TORQUE: float = 15.0
const ACCELERATION: float = 0.15
const DECCELERATION: float = 0.2
const TORQUE_GROWTH: float = 0.09

export var player_id: int
export var default_position: Vector2

var velocity: Vector2 = Vector2()
var torque: float = 0.0

	
func _physics_process(_delta):	
	var next_torque = torque
	if Input.is_action_pressed("player_%s_up" % player_id):
		velocity.y = lerp(velocity.y, -MAX_VELOCITY, ACCELERATION)
		next_torque = lerp(torque, -MAX_TORQUE, TORQUE_GROWTH)
	elif Input.is_action_pressed("player_%s_down" % player_id):
		velocity.y = lerp(velocity.y, MAX_VELOCITY, ACCELERATION)
		next_torque = lerp(torque, MAX_TORQUE, TORQUE_GROWTH)
	else:
		velocity.y = lerp(velocity.y, 0, DECCELERATION)
		next_torque = 0.0
		
	var collision: KinematicCollision2D = move_and_collide(velocity)
	
	# No collision, just apply the next torque.
	if collision == null:
		torque = next_torque
		return
	
	# Paddle hit the wall, torque is cancelled completely.	
	if collision.get_collider().is_in_group("wall"):
		torque = 0.0
	else:
		torque = next_torque
	
	
func reset():
	velocity = Vector2()
	position = default_position
