class_name ScreenShake
extends Node


const TRANSITION_TYPE = Tween.TRANS_SINE
const EASE_TYPE= Tween.EASE_IN_OUT
const DEFAULT_DURATION = 0.2
const DEFAULT_FREQUENCY = 16
const DEFAULT_AMPLITUDE = 16
const DEFAULT_PRIORITY = 0

var _amplitude = 0
var _priority = 0

onready var shake_tween: Tween = $ShakeTween
onready var frequency_timer: Timer = $Frequency
onready var duration_timer: Timer = $Duration
onready var camera = get_parent()


func start(duration = DEFAULT_DURATION, frequency = DEFAULT_FREQUENCY, 
		amplitude = DEFAULT_AMPLITUDE, priority = DEFAULT_PRIORITY):
	if priority < _priority:
		return
		
	_priority = priority
	_amplitude = amplitude

	duration_timer.wait_time = duration
	frequency_timer.wait_time = 1 / float(frequency)
	duration_timer.start()
	frequency_timer.start()

	_new_shake()

func _new_shake():
	var random_vector := Vector2()
	random_vector.x = rand_range(-_amplitude, _amplitude)
	random_vector.y = rand_range(-_amplitude, _amplitude)

	_tween_camera_offset(random_vector)


func _reset():
	_tween_camera_offset(Vector2())
	_priority = 0


func _on_Frequency_timeout():
	_new_shake()


func _on_Duration_timeout():
	_reset()
	frequency_timer.stop()
	
	
func _tween_camera_offset(vector: Vector2) -> void:
	shake_tween.interpolate_property(camera, "offset", camera.offset, vector,
			frequency_timer.wait_time, TRANSITION_TYPE, EASE_TYPE)
	shake_tween.start()
