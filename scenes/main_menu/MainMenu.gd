class_name MainMenu
extends MarginContainer


const GAME_SCENE_PATH = "res://scenes/game/Game.tscn"

onready var _play_1p_button: Button = $VBoxContainer2/Play1PButton
onready var _play_2p_button: Button = $VBoxContainer2/Play2PButton
onready var _options_button: Button = $VBoxContainer2/OptionsButton
onready var _button_hover_audio: AudioStreamPlayer = $ButtonHoverAudio
onready var _button_press_audio: AudioStreamPlayer = $ButtonPressAudio


func _unhandled_key_input(_event):
	if _play_1p_button.has_focus() \
			or _play_2p_button.has_focus() \
			or _options_button.has_focus():
		return
	
	_play_1p_button.grab_focus()


func _on_Button_mouse_entered():
	_button_hover_audio.play()


func _on_Button_focus_entered():
	if Input.is_mouse_button_pressed(1):
		return
		
	_button_hover_audio.play()
	

func _on_Play1PButton_pressed():
	_button_press_audio.play()
	GameSetting.is_against_ai = true
	yield(_button_press_audio, "finished")
	get_tree().change_scene(GAME_SCENE_PATH)


func _on_Play2PButton_pressed():
	_button_press_audio.play()
	GameSetting.is_against_ai = false
	yield(_button_press_audio, "finished")
	get_tree().change_scene(GAME_SCENE_PATH)


func _on_OptionsButton_pressed():
	_button_press_audio.play()
	yield(_button_press_audio, "finished")
