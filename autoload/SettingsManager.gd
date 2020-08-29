extends Node


const CONFIG_PATH := "res://settings.cfg"

var config := ConfigFile.new()


func _ready():
	var error = config.load(CONFIG_PATH)
	
	if error != OK:
		print("Config manager failed to load settings at path: %s, with error %s." % [CONFIG_PATH, error])


func save_setting(section: String, key: String, value):
	config.set_value(section, key, value)
	config.save(CONFIG_PATH)
	

func load_setting(section: String, key: String):
	return config.get_value(section, key)
