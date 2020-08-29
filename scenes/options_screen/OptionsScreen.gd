class_name OptionsScreen
extends Control


onready var crt_layer: CRTLayer = $CRTLayer
onready var crt_option: CheckButton = $MarginContainer/VSplitContainer/OptionsVbox/CRTOption 
onready var back_button: Button = $MarginContainer/VSplitContainer/BackButton


func _ready():
	crt_option.pressed = SettingsManager.load_setting("crt", "is_enabled")
	

func _on_option_focus():
	AudioManager.play(Audio.FOCUS)


func _on_BackButton_pressed():
	AudioManager.play(Audio.PRESS)
	get_tree().change_scene(GlobalPath.MAIN_MENU)


func _on_CRTOption_pressed():
	SettingsManager.save_setting("crt", "is_enabled", crt_option.pressed)
	crt_layer.update_effect()
	
