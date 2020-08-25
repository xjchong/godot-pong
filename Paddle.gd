class_name Paddle
extends KinematicBody2D


const MAX_VELOCITY: float = 15.0
const ACCELERATION: float = 0.15
const DECCELERATION: float = 0.2

export var player_id: int
export var default_position: Vector2

var velocity: Vector2 = Vector2()


func _ready():
	pass # Replace with function body.

	
func _physics_process(_delta):
	var next_velocity = velocity
	
	if Input.is_action_pressed("player_%s_up" % player_id):
		next_velocity.y = lerp(velocity.y, -MAX_VELOCITY, ACCELERATION)
	elif Input.is_action_pressed("player_%s_down" % player_id):
		next_velocity.y = lerp(velocity.y, MAX_VELOCITY, ACCELERATION)
	else:
		next_velocity.y = lerp(velocity.y, 0, DECCELERATION)
		
	velocity.y = clamp(next_velocity.y, -MAX_VELOCITY, MAX_VELOCITY)
		
# warning-ignore:return_value_discarded
	move_and_collide(velocity)
	
	
func reset():
	velocity = Vector2()
	position = default_position
