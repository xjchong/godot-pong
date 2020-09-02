class_name HintsOverlay
extends Control


onready var alpha_tween: Tween = $AlphaTween
onready var player_2_hints: VBoxContainer = $Player2Hints


func _ready():
	player_2_hints.visible = !GameSetting.is_against_ai
	SettingsManager.connect("settings_saved", self, "_on_settings_saved")
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
	SettingsManager.save_setting(self, "hints", "is_enabled", false)
	update_visibility()
	
	
func _on_settings_saved(emitter):
	if self == emitter:
		return
		
	update_visibility()
