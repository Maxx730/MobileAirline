extends Node

var TimeStamp: int = OS.get_unix_time()
var AirlineName: String = "Undefined"
var AirlineCallSign: String = "XXX"
var AirlineLogo: String = ""
var AirlineColor: Color = Color.white

# Level Data
var CurrentEXP: int = 0

# Array Data
var LocationData: Array = []
var FleetData: Array = []
var AvailableAircraft: Array = []

# Settings Data
var UseDaylight: bool = true

# Map Data
var MapSeed: int
var MapSize: int = Enums.WorldSizes.HUGE
var MapOctaves: int
var MapPeriod: float
var MapPersistence: float
var MapLacunarity: int

# Statistical Data
var CompletedFlights: int = 0

# World Tick
var ShouldTick: bool = true
var TickFrequency: float = 1.0
var LastTick: float = 0.0

signal PersistDataLoaded()
signal PersistLoadError()
signal PersistSaveSuccess()
signal PersistTick()

# General Methods
func Load() -> void:
	var rawData = Data.LoadData()
	if rawData:
		print("Data exists, initializing...")
		Initialize(rawData)
	else:
		print("Data does not exist, creating and initializing")
		Initialize(Save())
	
func Save() -> Dictionary:
	print("Saving Game Data...")
	var data = {
		"airline_name": AirlineName,
		"current_exp": CurrentEXP,
		"timestamp": OS.get_unix_time(),
		"locations": SerializeLocations(),
		"fleet": SerializeFleet(),
		"available": SerializeAvailable(),
		"logo": AirlineLogo,
		"color": str(AirlineColor),
		"call_sign": AirlineCallSign,
		"map": {
			"seed": MapSeed,
			"octaves": MapOctaves,
			"period": MapPeriod,
			"persistence": MapPersistence,
			"lacunarity": MapLacunarity
		},
		"stats": {
			"completed": CompletedFlights
		},
		"settings": {
			"use_daylight": UseDaylight
		}
	}
	Data.SaveData(data)
	emit_signal("PersistSaveSuccess")
	return data

func Clear() -> void:
	AirlineName = "Undefined"
	AirlineCallSign = "XXX"
	AirlineLogo = ""
	AirlineColor = Color.white
	FleetData = Array()
	LocationData = Array()
	AvailableAircraft = Array()
	

func Initialize(data) -> void:
	if data and data.has('timestamp') and data.has('airline_name') and data.has('current_exp') and data.has('locations') and data.has('fleet') and data.has('stats') and data.has('available') and data.has('color') and data.has('logo') and data.has('call_sign') and data.has('settings') and data.has("map"):
		TimeStamp = data.timestamp
		AirlineName = data.airline_name
		CurrentEXP = data.current_exp
		LocationData = ParseLocations(data.locations)
		FleetData = ParseFleet(data.fleet)
		CompletedFlights = data.stats.completed
		AvailableAircraft = data.available
		var colorValues = data.color.split(',')
		AirlineColor = Color(colorValues[0], colorValues[1], colorValues[2])
		AirlineLogo = data.logo
		AirlineCallSign = data.call_sign
		ParseSettings(data.settings)
		ParseMapSettings(data.map)
		emit_signal("PersistDataLoaded")
		ShouldTick = true
	else:
		printerr("ERROR: Unable to inistialize save data.")
		emit_signal("PersistLoadError")

func GetRandomSeed() -> int:
	randomize()
	return int(rand_range(0, 999999))

func TicksSinceLast() -> int:
	return 0

# Lifecycle Methods
func _notification(what: int) -> void:
	match what:
		MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
			# ONLY SAVE THE GAME IF A SAVE GAME 
			# FILE HAS ALREADY BEEN CREATED BY
			# NEW GAME MENU
			if Data.DataExists():
				pass

func _process(delta: float) -> void:
	if LastTick >= TickFrequency and ShouldTick:
		emit_signal("PersistTick")
		LastTick = 0.0
	LastTick += delta

# General Methods
func ParseSettings(settings: Dictionary) -> void:
	if settings.has("use_daylight"):
		UseDaylight = settings.use_daylight

func ParseMapSettings(map: Dictionary) -> void:
	MapSeed = map.seed
	MapLacunarity = map.lacunarity
	MapOctaves = map.octaves
	MapPeriod = map.period
	MapPersistence = map.persistence

func GetWorldMapTexture() -> ImageTexture:
	var image = Image.new()
	var err = image.load("user://generate-map.png")
	if err != OK:
		pass
		
	var texture = ImageTexture.new()
	texture.create_from_image(image, 0)
	return texture

func GetWorldMapImage() -> Image:
	var image = Image.new()
	var err = image.load("user://generate-map.png")
	if err != OK:
		return null
	else:
		return image

func GetWorldNoise() -> OpenSimplexNoise:
	var noise: OpenSimplexNoise = OpenSimplexNoise.new()
	noise.seed = MapSeed
	noise.lacunarity = MapLacunarity
	noise.persistence = MapPersistence
	noise.period = MapPeriod
	noise.octaves = MapOctaves
	return noise;

# Serialize Methods
func SerializeLocations() -> Array:
	var serialized = Array()
	for loc in LocationData:
		if loc is Location:
			serialized.append(
				loc.Serialize()
			)
	
	return serialized

func SerializeFleet() -> Array:
	var serialized: Array = Array()
	for aircraft in FleetData:
		if aircraft is Aircraft:
			serialized.append(aircraft.Serialize())
	return serialized

func SerializeAvailable() -> Array:
	var serialized: Array = Array()
	
	return serialized

# Deserialization Methods
func ParseLocations(data) -> Array:
	var locations: Array = Array()
	for location in data:
		if location is Dictionary:
			var newLoc = Location.new()
			newLoc.ID = location.id
			newLoc.Name = location.name
			newLoc.position = Vector2(location.point.x, location.point.y)
			newLoc.LocationType = location.type
			newLoc.CurrentWeather = location.weather
			newLoc.Unlocked = location.unlocked
			locations.append(newLoc)
	return locations

func ParseFleet(data) -> Array:
	var aircraft: Array = Array()
	for craft in data:
		if craft is Dictionary:
			var newCraft: Aircraft = Aircraft.new()
			newCraft.Name = craft.name
			newCraft.LocationID = craft.location.id
			newCraft.State = craft.state
			newCraft.DesignColor = craft.design.color
			newCraft.DesignTexture = load(craft.design.texture)
			newCraft.MaxFuel = craft.fuel.max
			newCraft.CurrentFuel = craft.fuel.current
			newCraft.FuelPerTick
			aircraft.append(newCraft)
	return aircraft
	
func ParseAvailable() -> Array:
	var available: Array = Array()
	
	return available
