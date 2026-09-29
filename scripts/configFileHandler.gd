extends Node

var config = ConfigFile.new()
const SETTINGS_FILE_PATH = "user://settings.ini"

func _ready():
	if !FileAccess.file_exists(SETTINGS_FILE_PATH):
		config.set_value("video", "fullscreen", true)
		config.set_value("audio", "master", 1.0)
		config.set_value("audio", "music", 1.0)
		config.set_value("audio", "effects", 1.0)
		
		config.save(SETTINGS_FILE_PATH)
	else:
		config.load(SETTINGS_FILE_PATH)

func save_settings(section: String, key: String, value):
	config.set_value(section,key,value)
	config.save(SETTINGS_FILE_PATH)

func load_settings(section: String):
	var settings = {}
	for key in config.get_section_keys(section):
		settings[key] = config.get_value(section, key)
	return settings
