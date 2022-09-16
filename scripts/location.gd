extends Node2D

class_name Location

const POTENTIAL_NAMES = [
	"Test 1",
	"Test 2",
	"Test 3"
]

var ID: int = 0
var Name: String = "Generic Location"
var Unlocked: bool = false
var CurrentWeather: int = Enums.WeatherStates.CLEAR
var LocationType: int = Enums.LocationTypes.NORMAL

# PERSIST METHODS
func Serialize() -> Dictionary:
	return {
		"id": ID,
		"unlocked": Unlocked,
		"name": Name,
		"weather": CurrentWeather,
		"type": LocationType,
		"point": {
			"x": position.x,
			"y": position.y
		}
	}

# RANDOMIZATION METHODS
func Randomize() -> void:
	randomize()
	ID = randi()
	Name = POTENTIAL_NAMES[rand_range(0, POTENTIAL_NAMES.size() - 1)]
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
func Spawn(locationSprite: Texture) -> Sprite:
	var sprite = Sprite.new()
	var material = ShaderMaterial.new()

	sprite.texture = locationSprite
	sprite.position = position
	sprite.z_index = 2
	sprite.name = "location-" + str(ID)
	return sprite
