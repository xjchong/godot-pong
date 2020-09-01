class_name MainMenu
extends MarginContainer


onready var _play_1p_button: Button = $VBoxContainer2/Play1PButton
onready var _play_2p_button: Button = $VBoxContainer2/Play2PButton
onready var _options_button: Button = $VBoxContainer2/OptionsButton


func _ready():
	var color_theme_index = SettingsManager.load_setting(
		"color_theme", "index", GameColor.DEFAULT_THEME_INDEX
	)
	
	GameColor.update_color_theme(color_theme_index)
	AudioManager.start_loop(Audio.MAIN_MENU_MUSIC)


func _unhandled_key_input(_event):
	if _play_1p_button.has_focus() \
			or _play_2p_button.has_focus() \
			or _options_button.has_focus():
		return
	
	_play_1p_button.grab_focus()


func _on_Button_mouse_entered():
	AudioManager.play(Audio.FOCUS)
	pass


func _on_Button_focus_entered():
	if Input.is_mouse_button_pressed(1):
		return
		
	AudioManager.play(Audio.FOCUS)
	

func _on_Play1PButton_pressed():
	AudioManager.play(Audio.PRESS)
	GameSetting.is_against_ai = true
	_change_scene_to_game_setup()


func _on_Play2PButton_pressed():
	AudioManager.play(Audio.PRESS)
	GameSetting.is_against_ai = false
	_change_scene_to_game_setup()


func _on_OptionsButton_pressed():
	AudioManager.play(Audio.PRESS)
	get_tree().change_scene(GlobalPath.OPTIONS)
	
	
func _change_scene_to_game_setup():
	get_tree().change_scene(GlobalPath.GAME_SETUP)
