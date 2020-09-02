extends Node


signal settings_saved(emitter)

const CONFIG_PATH := "user://settings.cfg"

var config := ConfigFile.new()


func _ready():
	var error = config.load(CONFIG_PATH)
	
	if error != OK:
		print("Config manager failed to load settings at path: %s, with error %s." % [CONFIG_PATH, error])


func save_setting(emitter, section: String, key: String, value):
	config.set_value(section, key, value)
	config.save(CONFIG_PATH)
	
	emit_signal("settings_saved", emitter)
	

func load_setting(section: String, key: String, default_value):
	return config.get_value(section, key, default_value)
