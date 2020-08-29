class_name OptionsScreen
extends Control


onready var crt_layer: CRTLayer = $CRTLayer
onready var sound_effects_option: OptionSlider = $MarginContainer/VSplitContainer/OptionsVbox/SoundEffectsSlider
onready var menu_music_option: OptionSlider = $MarginContainer/VSplitContainer/OptionsVbox/MenuMusicSlider
onready var crt_option: CheckButton = $MarginContainer/VSplitContainer/OptionsVbox/CRTOption 
onready var back_button: Button = $MarginContainer/VSplitContainer/BackButton


func _ready():
	crt_option.pressed = SettingsManager.load_setting("crt", "is_enabled", true)
	menu_music_option.set_value(SettingsManager.load_setting(
		"menu_music", "volume_percent", AudioManager.DEFAULT_VOLUME_PERCENT
	) * 100)
	
	
func _unhandled_key_input(_event):
	if Input.is_action_just_released("ui_cancel"):
		get_tree().change_scene(GlobalPath.MAIN_MENU)
		
	if (Input.is_action_pressed("ui_cancel")
			or sound_effects_option.has_focus() 
			or menu_music_option.has_focus()
			or crt_option.has_focus()
			or back_button.has_focus()):
		return
		
	sound_effects_option.grab_focus()


func _on_option_focus():
	if Input.is_mouse_button_pressed(1):
		return
		
	AudioManager.play(Audio.FOCUS)


func _on_BackButton_pressed():
	AudioManager.play(Audio.PRESS)
	get_tree().change_scene(GlobalPath.MAIN_MENU)


func _on_CRTOption_pressed():
	SettingsManager.save_setting("crt", "is_enabled", crt_option.pressed)
	crt_layer.update_effect()
	

func _on_MenuMusicSlider_value_changed(new_value: float):
	SettingsManager.save_setting("menu_music", "volume_percent", new_value)
	AudioManager.update_volume(AudioManager.Bus.BACKGROUND, new_value)
	

func _on_SoundEffectsSlider_value_changed(new_value):
	SettingsManager.save_setting("sound_effects", "volume_percent", new_value)
	AudioManager.update_volume(AudioManager.Bus.SOUND_EFFECTS, new_value)
	AudioManager.play(Audio.GAME_START)
