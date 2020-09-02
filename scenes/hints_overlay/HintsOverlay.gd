class_name HintsOverlay
extends Control


onready var alpha_tween: Tween = $AlphaTween
onready var player_2_hints: VBoxContainer = $Player2Hints


func _ready():
	player_2_hints.visible = !GameSetting.is_against_ai
	update_visibility()
	
	
func show():
	alpha_tween.interpolate_property(
		self, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 0.2)
	alpha_tween.start()
	
	
func hide():
	alpha_tween.interpolate_property(
		self, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.2)
	alpha_tween.start()


func update_visibility():
	visible = SettingsManager.load_setting("hints", "is_enabled", true)
	

func _on_HideHintsButton_pressed():
	SettingsManager.save_setting("hints", "is_enabled", false)
	update_visibility()
