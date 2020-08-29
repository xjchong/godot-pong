class_name CRTLayer
extends CanvasLayer


onready var crt_effect: ColorRect = $CRTEffect


func _ready():
	update_effect()
	
func update_effect():
	crt_effect.visible = SettingsManager.load_setting(
		"crt", "is_enabled", true
	)
