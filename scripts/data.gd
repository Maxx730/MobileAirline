extends Node

const DATA_FILENAME = "ma_data.json"
const MAP_FILENAME = "ma_map_data.json"

static func LoadData() -> Dictionary:
	var SaveFile = File.new()
	var data = null
	if SaveFile.file_exists("user://" + DATA_FILENAME):
		SaveFile.open("user://" + DATA_FILENAME, File.READ)
		data = parse_json(SaveFile.get_as_text())
		
	return data
	
static func SaveData(persist: Dictionary) -> Dictionary:
	var SaveFile = File.new()
	SaveFile.open("user://" + DATA_FILENAME, File.WRITE)
	SaveFile.store_string(to_json(persist))
	SaveFile.close()
	return persist
	
static func DataExists() -> bool:
	var SaveFile = File.new()
	return SaveFile.file_exists("user://" + DATA_FILENAME)

static func ClearData() -> void:
	print("Deleting currently saved data...")
	var SaveDir = Directory.new()
	SaveDir.remove("user://" + DATA_FILENAME)
