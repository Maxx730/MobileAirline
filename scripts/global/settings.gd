extends Node

const SETTINGS_FILE_NAME = "ma_settings.json"

var SETTINGS_OBJECT: Dictionary = {
	"use_dynamic_light": true
}

func Save() -> void:
	var SettingsFile = File.new()
	SettingsFile.open(
		"user://" + SETTINGS_FILE_NAME,
		File.WRITE
	)
	SettingsFile.store_string(
		to_json(
			SETTINGS_OBJECT
		)
	)
	SettingsFile.close()
	
func Load() -> void:
	var SettingsFile = File.new()
	SettingsFile.open(
		"user://" + SETTINGS_FILE_NAME,
		File.READ
	)
	SETTINGS_OBJECT = parse_json(SettingsFile.get_as_text())
	SettingsFile.close()
	
func SettingsExists() -> bool:
	var SettingsFile = File.new()
	return SettingsFile.file_exists("user://" + SETTINGS_FILE_NAME)
