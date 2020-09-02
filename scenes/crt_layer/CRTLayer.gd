class_name CRTLayer
extends CanvasLayer


onready var crt_effect: ColorRect = $CRTEffect


func _ready():
	SettingsManager.connect("settings_saved", self, "_on_settings_saved")
	update_effect()
	
	
func update_effect():
	crt_effect.visible = SettingsManager.load_setting(
		"crt", "is_enabled", true
	)
	
	
func _on_settings_saved(emitter):
	update_effect()
