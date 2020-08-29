class_name OptionSlider
extends HSplitContainer


signal value_changed(new_value)

const MIN_VALUE: int = 0
const MAX_VALUE: int = 100

export var title: String
export(int, 0, 100) var initial_value

onready var _label: Label = $Label
onready var _slider: HSlider = $HSlider


# Called when the node enters the scene tree for the first time.
func _ready():
	_label.text = title
	_slider.value = initial_value
	
	
func _on_HSlider_value_changed(value):
	set_value(value)


func _on_HSlider_focus_entered():
	if Input.is_mouse_button_pressed(1):
		return
		
	AudioManager.play(Audio.FOCUS)
	_label_focus()


func _on_HSplitContainer_mouse_entered():
	AudioManager.play(Audio.FOCUS)
	_label_focus()


func _on_HSplitContainer_mouse_exited():
	_label_unfocus()
	
	
func set_value(new_value: int):
	_slider.value = clamp(new_value, MIN_VALUE, MAX_VALUE)
	emit_signal("value_changed", float(_slider.value) / 100.0)
	
	
func _label_focus():
	_label.add_color_override("font_color", GameColor.FOCUS)
	

func _label_unfocus():
	_label.add_color_override("font_color", GameColor.FOREGROUND)
	
	
