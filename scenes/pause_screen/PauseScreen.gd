class_name PauseScreen
extends CanvasLayer


const MAX_BLUR := 2.8
const BLUR_DURATION := 0.2

onready var blur_rect: ColorRect = $BlurRect
onready var blur_tween: Tween = $BlurRect/BlurTween
onready var menu_container: MarginContainer = $BlurRect/MenuContainer
onready var resume_button: Button = $BlurRect/MenuContainer/VBoxContainer/ResumeButton
onready var options_button: Button = $BlurRect/MenuContainer/VBoxContainer/OptionsButton
onready var quit_button: Button = $BlurRect/MenuContainer/VBoxContainer/QuitButton
onready var options_screen: OptionsScreen = $BlurRect/OptionsScreen


func _ready():
	blur_rect.material.set_shader_param("blur", 0)
	options_screen.should_delegate_back_action = true
	
	
func _unhandled_key_input(event):
	if not menu_container.visible:
		return
		
	if Input.is_action_just_released("ui_cancel"):
		close()
		return

	if (Input.is_action_pressed("ui_cancel")
			or resume_button.has_focus()
			or options_button.has_focus()
			or quit_button.has_focus()):
		return
		
	resume_button.grab_focus()


func open():
	AudioManager.play(Audio.PRESS)
	get_tree().paused = true
	
	_tween_blur(MAX_BLUR)
	yield(blur_tween, "tween_completed")
	
	menu_container.visible = true
	

func close():
	AudioManager.play(Audio.PRESS)
	menu_container.visible = false

	_tween_blur(0)
	yield(blur_tween, "tween_completed")

	get_tree().paused = false


func _on_button_focus():
	if Input.is_mouse_button_pressed(1):
		return
		
	AudioManager.play(Audio.FOCUS)
	
	
func _tween_blur(blur_value):
	blur_tween.interpolate_property(
		blur_rect.material, "shader_param/blur", 
		blur_rect.material.get_shader_param("blur"), blur_value, BLUR_DURATION)
	blur_tween.start()
		
		
func _on_ResumeButton_pressed():
	close()
	
	
func _on_OptionsButton_pressed():
	menu_container.visible = false
	options_screen.visible = true
	
	
func _on_QuitButton_pressed():
	get_tree().paused = false
	get_tree().change_scene(GlobalPath.MAIN_MENU)
	

func _on_OptionsScreen_back_pressed():
	options_screen.visible = false
	menu_container.visible = true
