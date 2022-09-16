extends Node

class_name Record

onready var SaveTileMap: TileMap = get_node("map") as TileMap
onready var SaveButton: Button = get_node("ui/save") as Button

# Lifecycle Methods
func _ready() -> void:
	SaveButton.connect("pressed", self, "RecordMapData", [SaveTileMap])
	var mapData = LoadMapData()
	if mapData:
		ApplyMapData(SaveTileMap,mapData)
		SaveButton.visible = false

# Map Data Methods
func RecordMapData(data: Array) -> void:
	var recordFile = File.new()
	recordFile.open("user://mapData.json", File.WRITE)
	recordFile.store_string(to_json(data))
	recordFile.close()

func LoadMapData() -> Array:
	var dataFile = File.new() as File
	var data = null
	if dataFile.file_exists("user://mapData.json"):
		dataFile.open("user://mapData.json", File.READ)
		print("File exists, loading data...")
		data = parse_json(dataFile.get_as_text())
	return data

func ApplyMapData(map: TileMap, data: Array) -> void:
	if map:
		map.clear()
		for item in data:
			map.set_cell(item.cell.x, item.cell.y, item.value)
