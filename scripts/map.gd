extends TileMap

class_name Map

const WIDTH = 250
const HEIGHT = 250
const RADIUS = 300
const LOCATION_AMOUNT = 0
const MINIMUM_LOCATION_DISTANCE = RADIUS / 2

var SimplexNoise: OpenSimplexNoise
var GenerationThread: Thread
var FirstGen: bool = false
var LocationTemplate = preload("res://scenes/prefabs/location.tscn")

export(NodePath) var CloudPath

onready var OverworldParent = get_parent()
onready var CloudMap: Clouds = get_node(CloudPath)

signal OnGenerationFinished()

# Lifecycle Methods
func _ready() -> void:
	SimplexNoise = OpenSimplexNoise.new()
	SimplexNoise.period = 35.0
	SimplexNoise.octaves = 4
	SimplexNoise.persistence = 0.4
	SimplexNoise.lacunarity = 2
	
	GenerationThread = Thread.new()

# Generation Methods
func StartGeneration(mapSeed: int, firstGen: bool) -> void:
	Events.emit_signal("SetResumeMessage", "Building tilemap...")
	FirstGen = firstGen
	GenerationThread.start(self, "GenerateMap", mapSeed)
	
func GenerateMap(mapSeed: int) -> Dictionary:
	var LoadMapData = Data.LoadMapData()
	var MapData = Array()
	var CloudData = Array()
	
	if LoadMapData:
		Events.emit_signal("SetResumeMessage", "Loading tilemap...")
		MapData = LoadMapData
		SpawnLocations(Persist.LocationData)
	else:
		Events.emit_signal("SetResumeMessage", "Generating new tilemap...")
		SimplexNoise.seed = mapSeed
		
		for x in range(-RADIUS, RADIUS):
			for y in range(-RADIUS, RADIUS):
				var quard = Vector2(x, y)
				if quard.length() <= RADIUS:
					MapData.append(
						{
							"x": x,
							"y": y,
							"cell": GetCellType(SimplexNoise, x, y)
						}
					)
		Data.RecordMapData(MapData)

	call_deferred("EndGeneration")
	return {
		"MapData": MapData, 
		"CloudData": CloudData
	}

func EndGeneration() -> void:
	var data = GenerationThread.wait_to_finish()
	print("Map Generation Complete...")
	OverworldParent.SetStatusMessage("Tilemap Generation Finished")
	for cell in data.MapData:
		set_cell(cell.x, cell.y, cell.cell)
	CloudMap.ApplyData(data.CloudData)
	Persist.Save()
	Events.emit_signal("OverworldInitialized", FirstGen)

# General Methods
func GetCellType(noise: OpenSimplexNoise, x: int, y: int) -> int:
	var value = noise.get_noise_2d(x, y)
	var tile = 0 # base ocean
	
	# randomly determine if we should 
	# generate some seaweed
	randomize()
	var seaweedValue = randf()
	if seaweedValue > 0.75:
		tile = 9
	
	if value < -0.35:
		tile = 5 # deepest ocean
	elif value < -0.15:
		# check for deeper seaweed
		randomize()
		var deepSeaWeed = randf()
		
		if deepSeaWeed > 0.9:
			tile = 10
		else:
			tile = 3 # deep ocean
	
	if value > 0.2 and value < 0.35:
		OverworldParent.GenerateLocation(Vector2(x, y), FirstGen)
	
	if value > 0.52:
		tile = 8 # snow
	elif value > 0.42:
		tile = 7 # mountain
	elif value > 0.35:
		tile = 6 # dirt
	elif value > 0.23:
		randomize()
		var treeDeepSpawnValue = randf()
		if treeDeepSpawnValue > 0.7:
			tile = 12
		else:
			tile = 4 # main land
	elif value > 0.1:
		randomize()
		var treeSpawnValue = randf()
		if treeSpawnValue > 0.95:
			tile = 11
		else:
			tile = 1 # light grass
	elif value > 0.0:
		randomize()
		var palmSpawnValue = randf()
		if palmSpawnValue > 0.975:
			tile = 13
		else:
			tile = 2 # sand
	
	return tile

func SpawnLocations(locations: Array) -> void:
	if LocationTemplate:
		for location in locations:
				if LocationTemplate:
					var newLoc = LocationTemplate.instance() as Location
					newLoc.position = Vector2(location.position.x, location.position.y)
					newLoc.PersistData = location
					get_parent().Locations.add_child(newLoc)
