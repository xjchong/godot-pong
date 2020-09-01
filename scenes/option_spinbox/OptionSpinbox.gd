class_name OptionSpinbox
extends HBoxContainer


signal value_changed(new_value)

export var title: String
export var min_value: int = 0
export var max_value: int = 99

onready var title_label: Label = $TitleLabel
onready var minus_button: Button = $MinusButton
onready var value_label: Label = $ValueLabel
onready var plus_button: Button = $PlusButton
onready var hidden_slider: HSlider = $HiddenSlider
	
export var value: int = 0 setget value_set


func value_set(new_value):
	value = new_value
	hidden_slider.value = new_value

func _ready():
	title_label.text = title
	
	hidden_slider.min_value = min_value
	hidden_slider.max_value = max_value
	hidden_slider.value = value
	
	value_label.text = str(hidden_slider.value)

func _process(_delta):
	if not has_focus():
		return

	
	minus_button.pressed = Input.is_action_pressed("ui_left")
	plus_button.pressed = Input.is_action_pressed("ui_right")
	
	minus_button.add_color_override("font_color", 
		GameColor.FOCUS if Input.is_action_pressed("ui_left") else GameColor.FOREGROUND
	)
	
	plus_button.add_color_override("font_color", 
		GameColor.FOCUS if Input.is_action_pressed("ui_right") else GameColor.FOREGROUND
	)

	
func _on_HboxContainer_mouse_entered():
	_focus_control(title_label)


func _on_HboxContainer_mouse_exited():
	_unfocus_control(title_label)
	

func _on_HiddenSlider_focus_entered():		
	_focus_control(title_label)
	
	
func _on_HiddenSlider_focus_exited():
	_unfocus_control(title_label)
	

func _on_HiddenSlider_value_changed(new_value):
	value_label.text = str(new_value)
	emit_signal("value_changed", new_value)


func _on_MinusButton_pressed():
	hidden_slider.value -= 1


func _on_PlusButton_pressed():
	hidden_slider.value += 1

	
func has_focus() -> bool:
	return hidden_slider.has_focus()
	
	
func grab_focus():
	hidden_slider.grab_focus()
	
	
func _focus_control(control):
	emit_signal("focus_entered")
	control.add_color_override("font_color", GameColor.FOCUS)
	

func _unfocus_control(control):
	control.add_color_override("font_color", GameColor.FOREGROUND)
