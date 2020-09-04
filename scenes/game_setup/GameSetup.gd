class_name GameSetup
extends MarginContainer


onready var title_label: Label = $VSplitContainer/VBoxContainer/TitleContainer/TitleLabel
onready var game_points_option: OptionSpinbox = $VSplitContainer/VBoxContainer/GamePointsOption
onready var match_games_option: OptionSpinbox = $VSplitContainer/VBoxContainer/MatchGamesOption
onready var deuce_option: CheckButton = $VSplitContainer/VBoxContainer/DeuceOption
onready var ai_option: OptionSpinbox = $VSplitContainer/VBoxContainer/AiOptionContainer/AiOption
onready var back_button: Button = $VSplitContainer/HBoxContainer3/BackButton
onready var play_button: Button = $VSplitContainer/HBoxContainer3/PlayButton

var is_against_ai: bool
var section: String 

var game_points: int
var match_games: int
var is_deuce_enabled: bool
var ai: int

var _is_ready := false


func _ready():
	is_against_ai = GameSetting.is_against_ai
	section = "1p_match" if is_against_ai else "2p_match"
	title_label.text = "1P Match" if is_against_ai else "2P Match"
	
	game_points = SettingsManager.load_setting(section, "game_points", 11)
	match_games = SettingsManager.load_setting(section, "match_games", 3)
	is_deuce_enabled = SettingsManager.load_setting(section, "is_deuce_enabled", true)
	
	if is_against_ai:
		ai = SettingsManager.load_setting("1p_match", "ai", 2)
		_update_ai_option_label()
		ai_option.value = ai
	else:
		ai_option.hide()
	
	game_points_option.value = game_points
	match_games_option.value = match_games
	deuce_option.pressed = is_deuce_enabled
	
	_is_ready = true


func _unhandled_key_input(_event):
	if Input.is_action_just_released("ui_cancel"):
		_on_BackButton_pressed()
		return	
	
	if (Input.is_action_pressed("ui_cancel")
			or game_points_option.has_focus()
			or match_games_option.has_focus()
			or deuce_option.has_focus()
			or ai_option.has_focus()
			or back_button.has_focus()
			or play_button.has_focus()):
		return

	game_points_option.grab_focus()
	
	
func _on_option_focus():
	if Input.is_mouse_button_pressed(1):
		return
		
	AudioManager.play(Audio.FOCUS)
	

func _on_GamePointsOption_value_changed(new_value):
	game_points = new_value

	if _is_ready:
		AudioManager.play(Audio.PRESS)
		
		
func _on_MatchGamesOption_value_changed(new_value):
	match_games = new_value
	
	if _is_ready:
		AudioManager.play(Audio.PRESS)


func _on_DeuceOption_toggled(button_pressed):
	is_deuce_enabled = button_pressed
	
	if _is_ready:
		AudioManager.play(Audio.PRESS)
		

func _on_AiOption_value_changed(new_value):
	ai = new_value
	_update_ai_option_label()
	
	if _is_ready:
		AudioManager.play(Audio.PRESS)


func _on_BackButton_pressed():
	AudioManager.play(Audio.PRESS)
	get_tree().change_scene(GlobalPath.MAIN_MENU)


func _on_PlayButton_pressed():
	SettingsManager.save_setting(self, section, "game_points", game_points)
	SettingsManager.save_setting(self, section, "match_games", match_games)
	SettingsManager.save_setting(self, section, "is_deuce_enabled", is_deuce_enabled)
	
	if GameSetting.is_against_ai:
		SettingsManager.save_setting(self, "1p_match", "ai", ai)
	
	AudioManager.play(Audio.PRESS)
	AudioManager.end_loop()
	get_tree().change_scene(GlobalPath.GAME)
	
	
func _update_ai_option_label():
	if ai_option == null:
		return
		
	var format_string = "AI (%s)"
	
	match ai:
		1:
			ai_option.set_title(format_string % "lazy")
		2:
			ai_option.set_title(format_string % "normy")
		3:
			ai_option.set_title(format_string % "spinny")
		4:
			ai_option.set_title(format_string % "spikey")
		5:
			ai_option.set_title(format_string % "boss")

