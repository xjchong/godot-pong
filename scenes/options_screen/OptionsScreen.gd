class_name OptionsScreen
extends Control


signal back_pressed()

onready var sound_effects_option: OptionSlider = $MarginContainer/VSplitContainer/OptionsVbox/SoundEffectsSlider
onready var menu_music_option: OptionSlider = $MarginContainer/VSplitContainer/OptionsVbox/MenuMusicSlider
onready var crt_option: CheckButton = $MarginContainer/VSplitContainer/OptionsVbox/CRTOption 
onready var screen_shake_option: CheckButton = $MarginContainer/VSplitContainer/OptionsVbox/ScreenShakeOption
onready var color_theme_option: OptionSpinbox = $MarginContainer/VSplitContainer/OptionsVbox/ColorThemeOption
onready var hide_controls_options: CheckButton = $MarginContainer/VSplitContainer/OptionsVbox/HideControlsOption
onready var back_button: Button = $MarginContainer/VSplitContainer/BackButton

var should_delegate_back_action := false
var _is_ready = false


func _ready():
	SettingsManager.connect("settings_saved", self, "_on_settings_saved")
	_update_settings()
	_is_ready = true
	
	
func _unhandled_key_input(event):
	if not visible:
		return
	else:
		accept_event()
		
	if event.is_action("ui_select") or event.is_action("ui_accept"):
		return
	
	if event.is_action_released("ui_cancel"):
		_on_BackButton_pressed()
		return
		
	if (event.is_action_pressed("ui_cancel")
			or sound_effects_option.has_focus() 
			or menu_music_option.has_focus()
			or crt_option.has_focus()
			or screen_shake_option.has_focus()
			or color_theme_option.has_focus()
			or hide_controls_options.has_focus()
			or back_button.has_focus()):
		return
		
	sound_effects_option.grab_focus()


func _on_option_focus():
	if Input.is_mouse_button_pressed(1):
		return

	AudioManager.play(Audio.FOCUS)


func _on_BackButton_pressed():
	AudioManager.play(Audio.PRESS)
	
	if should_delegate_back_action:
		emit_signal("back_pressed")
	else:
		get_tree().change_scene(GlobalPath.MAIN_MENU)


func _on_CRTOption_pressed():
	AudioManager.play(Audio.PRESS)
	SettingsManager.save_setting(self, "crt", "is_enabled", crt_option.pressed)
	

func _on_ScreenShakeOption_pressed():
	AudioManager.play(Audio.PRESS)
	SettingsManager.save_setting(self,"screen_shake", "is_enabled", screen_shake_option.pressed)
	

func _on_MenuMusicSlider_value_changed(new_value: float):
	if not _is_ready or not visible:
		return
		
	SettingsManager.save_setting(self, "menu_music", "volume_percent", new_value)
	AudioManager.update_volume(AudioManager.Bus.BACKGROUND, new_value)
	

func _on_SoundEffectsSlider_value_changed(new_value):
	if not _is_ready or not visible:
		return
		
	SettingsManager.save_setting(self, "sound_effects", "volume_percent", new_value)
	AudioManager.update_volume(AudioManager.Bus.SOUND_EFFECTS, new_value)
	AudioManager.play(Audio.GAME_START)


func _on_ColorThemeOption_value_changed(new_value):
	if not _is_ready or not visible:
		return
	
	AudioManager.play(Audio.PRESS)
	SettingsManager.save_setting(self, "color_theme", "index", new_value)
	GameColor.update_color_theme(new_value)


func _on_HideControlsOption_pressed():
	if not _is_ready or not visible:
		return
	
	AudioManager.play(Audio.PRESS)
	SettingsManager.save_setting(self, "hints", "is_enabled", !hide_controls_options.pressed)
	
	
func _on_settings_saved(emitter):
	if emitter == self:
		return
	
	_update_settings()
	
func _update_settings():
	sound_effects_option.set_value(SettingsManager.load_setting(
		"sound_effects", "volume_percent", AudioManager.DEFAULT_SOUND_VOLUME_PERCENT
	) * 100)
	
	menu_music_option.set_value(SettingsManager.load_setting(
		"menu_music", "volume_percent", AudioManager.DEFAULT_MUSIC_VOLUME_PERCENT
	) * 100)
	
	crt_option.pressed = SettingsManager.load_setting("crt", "is_enabled", true)
	
	screen_shake_option.pressed = SettingsManager.load_setting(
		"screen_shake", "is_enabled", true
	)
	
	color_theme_option.max_value = GameColor.color_themes.size() - 1
	color_theme_option.value = SettingsManager.load_setting(
		"color_theme", "index", GameColor.DEFAULT_THEME_INDEX
	)
	
	hide_controls_options.pressed = !SettingsManager.load_setting(
		"hints", "is_enabled", true
	)
