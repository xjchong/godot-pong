class_name OptionsScreen
extends Control


onready var back_button: Button= $MarginContainer/VSplitContainer/BackButton


func _on_option_focus():
	AudioManager.play(Audio.FOCUS)


func _on_BackButton_pressed():
	AudioManager.play(Audio.PRESS)
	get_tree().change_scene(GlobalPath.MAIN_MENU)
