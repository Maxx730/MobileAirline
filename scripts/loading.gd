extends Control

class_name Loading

const MAP_EDGE_OFFSET = 200
const MAX_LOCATION_AMOUNT = 20
const MIN_DISTANCE_BETWEEN_LOCATIONS = 250

export(Texture) var LocationSprite
export(DynamicFont) var ListItemFont

# Generation Nodes
var MapImgGenTemplate: PackedScene = preload("res://scenes/prefabs/map_image_generation.tscn")
var LocationTemplate: PackedScene = preload("res://scenes/prefabs/location.tscn")
var InitialAircraftTemplate: PackedScene = preload("res://scenes/prefabs/aircraft/generic-passenger.tscn")
var SecondaryAircraftTemplate: PackedScene = preload("res://scenes/prefabs/aircraft/generic.tscn")

# UI Elements
onready var LoadingBar: ProgressBar = get_node("top/amount")
onready var StatusLabel: Label = get_node("top/status")
onready var GenerationLog: Panel = get_node("generation_log")
onready var RootFrame: Node = get_node("../../")
onready var ContinueButton: Button = get_node("bottom/continue")
onready var EntranceMessage: Panel = get_node("top/message")


var GenerationThread: Thread
var PreviewRef: Sprite
var LocationGenThread: Thread

# Lifecycle Methods
func _ready() -> void:
	# DETERMINE IF A SAVE GAME HAS ALREADY BEEN
	# CREATED, IF SO THEN CHECK IF THERE ARE
	# ANY LOCATIONS, IF NOT THEN WE NEED TO 
	# GENERATE NEW LOCATIONS.
	if Data.DataExists():
		if Persist.LocationData.size() > 0:
			# PREVIOUS GAME LOCATIONS EXIST
			# MOVE PLAYER ONTO THE GAMEPLAY
			# SCREEN
			get_tree().change_scene("res://scenes/screens/gameplay.tscn")
		else:
			if ContinueButton:
				ContinueButton.connect("pressed", self, "OnContinuePressed")
			if GenerationLog:
				var mapImgGen: MapImageGenerator = MapImgGenTemplate.instance()
				mapImgGen.connect("MapGenerationComplete", self, "OnMapImageGenerationComplete")
				mapImgGen.connect("MapGenerationUpdate", self, "SetLoadingLevel")
				add_child(mapImgGen)
				#GenerationLog.visible = true
				randomize()
				AddMessageGenerationList("Generating world map with seed (" + str(Persist.MapSeed) + ")...")
				mapImgGen.GenerateWorldMap(LoadingBar, StatusLabel)
	else:
		SetStatusLabel("ERROR: Game data does not exist. Please return to main menu.")

# General Methods
func SetStatusLabel(message: String) -> void:
	if StatusLabel:
		StatusLabel.text = message

func SetLoadingLevel(amnt: int) -> void:
	if LoadingBar:
		LoadingBar.value = amnt

func AddMessageGenerationList(message: String) -> void:
	if GenerationLog and GenerationLog.get_child(0).get_child(0):
		var newItem: Label = Label.new()
		newItem.text = message
		newItem.rect_min_size = Vector2(0, 24)
		newItem.valign = VALIGN_CENTER
		
		if ListItemFont:
			newItem.add_font_override("font", ListItemFont)
		
		GenerationLog.get_child(0).get_child(0).add_child(newItem)

# Generation Methods
func GenerateWorldLocations() -> bool:
	var size: Vector2 = Persist.GetWorldMapTexture().get_size()
	var noise: OpenSimplexNoise = Persist.GetWorldNoise()
	var waterLevel: float = Persist.MapWaterLevel - 0.5
	
	for i in range(MAX_LOCATION_AMOUNT):
		pass
	
	SetLoadingLevel(LoadingBar.value + amountDone)
	SetStatusLabel(str(clamp(LoadingBar.value + amountDone, 0, 100)) + "%")
	
	call_deferred("LocationGenerationFinished")
	return true
	
func GenerateInitialAircraft(secondary: bool) -> Aircraft:
	var newAircraft: Aircraft = InitialAircraftTemplate.instance() if !secondary else SecondaryAircraftTemplate.instance()
	newAircraft.Name = "Early Horizons" if !secondary else "Late Horizons"
	newAircraft.ResourcePath = InitialAircraftTemplate.resource_path if !secondary else SecondaryAircraftTemplate.resource_path
	return newAircraft
	
func IsLocationIsolated(location: Vector2) -> bool:
	var isolated: bool = true
	
	for loc in Persist.LocationData:		
		if loc.position.distance_to(location) < MIN_DISTANCE_BETWEEN_LOCATIONS:
			isolated = false
			break
	
	return IsAwayFromEdges(location) and isolated

func ShouldSpawnLocation() -> bool:
	randomize()
	return false

func IsAwayFromEdges(location: Vector2) -> bool:
	var totalSize = (Persist.MapSize + 1) * 1000
	return location.x > MAP_EDGE_OFFSET and location.x < (totalSize - MAP_EDGE_OFFSET) and location.y > MAP_EDGE_OFFSET and location.y < (totalSize - MAP_EDGE_OFFSET)


# Connected Methods
func OnMapImageGenerationComplete() -> void:
	AddMessageGenerationList("Map image generation complete!")
	AddMessageGenerationList("Generating airport locations...")
	AddMapPreview()
	LocationGenThread = Thread.new()
	LocationGenThread.start(self, "GenerateWorldLocations")

func LocationGenerationFinished() -> void:
	var success = LocationGenThread.wait_to_finish()
	var InitialFirst: Aircraft = GenerateInitialAircraft(false)
	var InitialSecond: Aircraft = GenerateInitialAircraft(true)
	
	Persist.LocationData[0].Unlocked = true
	Persist.LocationData[1].Unlocked = true
	Persist.LocationData[2].Unlocked = true
	
	InitialFirst.LocationID = Persist.LocationData[0].ID
	InitialFirst.MapPosition = Persist.GetLocationFromLocationId(InitialFirst.LocationID).position
	InitialSecond.LocationID = Persist.LocationData[1].ID
	InitialSecond.MapPosition = Persist.GetLocationFromLocationId(InitialSecond.LocationID).position

	
	Persist.FleetData.append(InitialFirst)
	Persist.FleetData.append(InitialSecond)
	
	AddMessageGenerationList("Generation of locations complete.")
	SetStatusLabel("Map Generation Complete!")
	SetLoadingLevel(100)
	Persist.Save()
	if ContinueButton:
		ContinueButton.visible = true
		
	if EntranceMessage:
		EntranceMessage.visible = false

func OnContinuePressed() -> void:
	get_tree().change_scene("res://scenes/screens/gameplay.tscn")

# Util Methods
func AddMapPreview() -> void:
	var mapTexture = Sprite.new()
	var previewScale = 1
	mapTexture.name = "generated_map_preview"
	mapTexture.texture = Persist.GetWorldMapTexture()
	PreviewRef = mapTexture
	mapTexture.centered = false
	mapTexture.scale = Vector2(previewScale, previewScale)
	mapTexture.visible = false
	RootFrame.add_child(mapTexture)
	RootFrame.move_child(mapTexture, 0)
