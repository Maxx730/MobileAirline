extends Screen

class_name Overworld

const MINIMUM_LOCATION_DISTANCE = 300
const TOTAL_LOCATION_COUNT = 0
const LOCATION_NAMES = {}

export(NodePath) var CameraPath

onready var CameraRef: Camera2D = get_node(CameraPath)

var LocationTemplate = preload("res://scenes/prefabs/location.tscn")
var MouseDown: bool = false
var PotentialNames: Array = [
	"Bunker Hill Village",
	"Somers Point",
	"Tiburones",
	"Robertsdale",
	"Yerington",
	"Harvard",
	"Jasonville",
	"Detmold",
	"McCullom Lake",
	"Clearlake",
	"South Salem",
	"Glenvil",
	"Yucca",
	"Wibaux",
	"Nicolaus",
	"Cobbtown",
	"Surfside",
	"Hayden",
	"Penitas",
	"Nanawale Estates",
	"Cross Anchor",
	"Cheval",
	"Hubbard Lake",
	"Idanha",
	"Clarkesville",
	"Las Ollas",
	"Puerto Real",
	"Howland",
	"Olsburg",
	"Bosworth",
	"Sugartown",
	"Campbellton",
	"Bellview",
	"Rachel",
	"Marshalltown",
	"Powhatan",
	"Felts Mills",
	"Norris City",
	"Centralhatchee",
	"Norridgewock",
	"East Islip",
	"Taos Pueblo",
	"Albert Lea",
	"Lawtell",
	"Oriskany Falls",
	"Havre North",
	"Quail Creek",
	"McKenney",
	"Marklesburg",
	"Salt Lake City"
]

onready var WorldMap: Map = get_node("map")
onready var Locations: Node = get_node("locations")

# Switcher Elements
onready var LeftButton: Button = get_node("ui/switcher/background/actions/left")
onready var RightButton: Button = get_node("ui/switcher/background/actions/right")
onready var LocationNameLabel: Label = get_node("ui/switcher/background/actions/center/name")

# Debug UI Elements
onready var StatusMessage: Label = get_node("ui/debug/status")

# Lifecycle Methods
func _ready() -> void:
	get_parent().get_parent().connect("DataLoaded", self, "OnLoadReady")
	Events.connect("OverworldInitialized", self, "OnGenerationFinished")
	LeftButton.connect("pressed", self, "OnPreviousLocation")
	RightButton.connect("pressed", self, "OnNextLocation")

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_LEFT:
			MouseDown = true
		elif event.button_index == BUTTON_LEFT:
			MouseDown = false
	
	if event is InputEventMouseMotion:
		if MouseDown:
			if CameraRef:
				CameraRef.position -= event.relative

# Connected Methods
func OnLoadReady() -> void:
	print("Generating Overworld Map: " + str(Persist.MapSeed))
	if WorldMap:
		WorldMap.StartGeneration(Persist.MapSeed, Persist.LocationData.size() == 0)

func OnGenerationFinished(firstGen) -> void:
	Events.emit_signal("CameraTargetChange", Locations.get_child(Persist.FocusedLocation))
	if LocationNameLabel and Persist.LocationData.size() > 0:
		LocationNameLabel.text = Persist.LocationData[Persist.FocusedLocation].name

func OnNextLocation() -> void:
	if Persist.FocusedLocation + 1 < Persist.LocationData.size():
		Persist.FocusedLocation += 1
	else:
		Persist.FocusedLocation = 0
		
	SetCameraTarget(Persist.FocusedLocation)
	
func OnPreviousLocation() -> void:
	if Persist.FocusedLocation - 1 >= 0:
		Persist.FocusedLocation -= 1
	else:
		Persist.FocusedLocation = Persist.LocationData.size() - 1
		
	SetCameraTarget(Persist.FocusedLocation)
		
func SetCameraTarget(location: int) -> void:
	Events.emit_signal("CameraTargetChange", Locations.get_child(location))
	var data = Persist.LocationData[location]
	if LocationNameLabel:
		LocationNameLabel.text = data.name

# General Methods
func GenerateLocation(point: Vector2, FirstGen: bool) -> void:
	if !FirstGen:
		for location in Persist.LocationData:
			var worldPoint = WorldMap.map_to_world(point)
			if location.position.x == worldPoint.x and location.position.y == worldPoint.y:
				if LocationTemplate:
					var newLoc = LocationTemplate.instance() as Location
					newLoc.position = worldPoint
					newLoc.PersistData = location
					Locations.add_child(newLoc)			
	else:

		if LocationTemplate and Locations.get_child_count() < TOTAL_LOCATION_COUNT:
			var worldPoint = WorldMap.map_to_world(point)
			if self.LocationIsolated(worldPoint) and (point.x > -WorldMap.RADIUS / 2) and (point.y > -WorldMap.RADIUS / 2) and (point.y < WorldMap.RADIUS / 2):
				randomize()
				var newLoc = LocationTemplate.instance() as Location
				var data = {
					"name": GetRandomLocationName(PotentialNames),
					"id": GetRandomLocationId(),
					"position": {
						"x": worldPoint.x,
						"y": worldPoint.y
					}
				}
				newLoc.position = worldPoint
				newLoc.PersistData = data
				Locations.add_child(newLoc)
				Persist.LocationData.append(data)

func LocationIsolated(point: Vector2) -> bool:
	var isIsolated: bool = true
	for location in Locations.get_children():
		if location.position.distance_to(point) < MINIMUM_LOCATION_DISTANCE:
			isIsolated = false
	return isIsolated

func GetRandomLocationId() -> int:
	randomize()
	var id = randi()
	while LocationIdExists(id):
		id = randi()
		
	return id

func LocationIdExists(id: int) -> bool:
	var hasId = false
	for location in Persist.LocationData:
		if location.id == id:
			hasId = true
			
	return hasId

func GetRandomLocationName(names: Array) -> String:
	randomize()
	var name = names[rand_range(0, names.size() - 1)]
	while NameExists(name, Persist.LocationData):
		name = names[rand_range(0, names.size() - 1)]
	return name

func NameExists(name, locations) -> bool:
	var hasName: bool = false
	for location in locations:
		if location.name == name:
			hasName = true
	return hasName

# Debug Methods
func SetStatusMessage(message: String) -> void:
	if StatusMessage:
		StatusMessage.text = message
