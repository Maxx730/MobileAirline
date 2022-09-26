extends Node2D

class_name Location

var POTENTIAL_NAMES: Array = [
	"Keone Reef",
	"Kala Reef",
	"Nohea Bay",
	"Bane Island",
	"Hanalei  Haven",
	"Noelani  Haven",
	"Luana Retreat",
	"Kai Rock",
	"Luana Sanctuary",
	"Nohea Tropic",
	"Bane Isles",
	"Tua Bay",
	"Lala Reef",
	"Bane Haven",
	"Kailano  Land",
	"Keone Bay",
	"Kauai  Springs",
	"Luana Bay",
	"Hanalei  Springs",
	"Loe Land",
	"Kala Isles",
	"Aloha Sanctuary",
	"Noelani  Sanctuary",
	"Luana Rock",
	"Lala Retreat",
	"Moana Isles",
	"Nohea Shores",
	"Loe Sanctuary",
	"Kauai  Bay",
	"Aloha Rock",
	"Loe Shores",
	"Kauai  Sanctuary",
	"Kauai  Land",
	"Moana Retreat",
	"Noelani  Springs",
	"Kai Springs",
	"Holokai  Sanctuary",
	"Nohea Rock",
	"Kai Shores",
	"Holokai  Bay",
	"Moana Reef",
	"Kailano  Retreat",
	"Keone Shores",
	"Holokai  Tropic",
	"Tua Tropic",
	"Lala Island",
	"Lala Tropic",
	"Aloha Shores",
	"Aloha Springs",
	"Keone Retreat",
	"Kai Sanctuary",
	"Kala Springs",
	"Leilani Reef",
	"Holokai  Haven",
	"Kauai  Tropic",
	"Kailani  Rock",
	"Lala Rock",
	"Aloha Haven",
	"Holokai  Rock",
	"Lala Isles",
	"Loe Springs",
	"Bane Reef",
	"Holokai  Retreat",
	"Tua Retreat",
	"Kai Bay",
	"Noelani  Bay",
	"Tua Reef",
	"Kailani  Isles",
	"Nohea Reef",
	"Kailano  Haven",
	"Kala Rock",
	"Kai Tropic",
	"Kai Land",
	"Nohea Retreat",
	"Tua Shores",
	"Kailani  Retreat",
	"Hanalei  Land",
	"Leilani Haven",
	"Moana Tropic",
	"Kauai  Isles",
	"Lala Springs",
	"Aloha Land",
	"Aloha Retreat",
	"Keone Isles",
	"Kai Haven",
	"Nohea Sanctuary",
	"Noelani  Rock",
	"Bane Tropic",
	"Kailani  Reef",
	"Loe Retreat",
	"Holokai  Island",
	"Tua Springs",
	"Keone Island",
	"Leilani Shores",
	"Luana Shores",
	"Kala Island",
	"Loe Haven",
	"Holokai  Springs",
	"Keone Haven",
	"Lala Haven",
	"Kala Land",
	"Keone Tropic",
	"Bane Rock",
	"Keone Springs",
	"Bane Springs",
	"Luana Land",
	"Tua Land",
	"Keone Land",
	"Bane Retreat",
	"Holokai  Land",
	"Noelani  Isles",
	"Luana Tropic",
	"Moana Island",
	"Hanalei  Shores"
]

var ID: int = 0
var Name: String = "Generic Location"
var Unlocked: bool = false
var CurrentWeather: int = Enums.WeatherStates.CLEAR
var LocationType: int = Enums.LocationTypes.NORMAL
var LocationSize: int = Enums.LocationSizes.SMALL

# LIFECYLE METHODS
func _ready() -> void:
	Persist.connect("PersistTick", self, "OnWorldTick")

# PERSIST METHODS
func Serialize() -> Dictionary:
	return {
		"id": ID,
		"unlocked": Unlocked,
		"name": Name,
		"weather": CurrentWeather,
		"type": LocationType,
		"size": LocationSize,
		"point": {
			"x": position.x,
			"y": position.y
		}
	}

# RANDOMIZATION METHODS
func Randomize() -> void:
	randomize()
	ID = randi()
	var NameId = rand_range(0, POTENTIAL_NAMES.size() - 1)
	Name = POTENTIAL_NAMES[rand_range(0, POTENTIAL_NAMES.size() - 1)]
	POTENTIAL_NAMES.remove(NameId)
	LocationType = rand_range(0, Enums.LocationTypes.size() - 1)
	while !IsIDUnique(ID):
		ID = randi()

func IsIDUnique(id: int) -> bool:
	var unique: bool = true
	for loc in Persist.LocationData:
		if loc.ID == id:
			unique = false
			break
	return unique

func IsNameUnique(name: String) -> bool:
	var unique: bool = true
	for loc in Persist.LocationData:
		if loc.Name == name:
			unique = false
			break
	return unique

# SPAWN METHODS
func Spawn(locationSprite: Texture, locationUi: Node2D = null) -> Node2D:
	var locName: Label = locationUi.get_node("name")
		
	if locName:
		locName.text = Name
	return locationUi

# GENERAL METHODS
func OnWorldTick() -> void:
	# ONLY SPAWN NEW CARGO ON LOCATIONS THAT 
	# ARE UNLOCKED AND ONLY SET DESTINATIONS 
	# FOR UNLOCKED LOCATIONS
	var maxAmount = (LocationSize + 1) * 10
	if ShouldSpawnCargo() and self.Unlocked and Persist.GetLocationCargo(self.ID).size() < maxAmount:
		randomize()
		var cargo: Cargo = Cargo.new()
		var potentialDest: Array = Persist.GetPotentialDestinations(self.ID)
		
		cargo.Location = self.ID
		cargo.Destination = potentialDest[rand_range(0, potentialDest.size())].ID
		
		Persist.AvailableCargo.append(cargo)
		
	
func ShouldSpawnCargo() -> bool:
	randomize()
	return randf() < 0.05
