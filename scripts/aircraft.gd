extends Node2D

class_name Aircraft

##############
# GENERAL    #
##############
export var Name = "Generic Airbus"
var State: int = Enums.AircraftStates.LANDED
var LocationID: int = 0
var ResourcePath: String
var MapPosition: Vector2

#########
# FUEL  #
#########
export var Speed: int = 2000
export var MaxFuel: float = 100.0
export var MilesPerGallon: float = 5.0
var Destination: int = -1
var CurrentFuel: float = 100.0

##############
# LOGO/COLOR #
##############
var DesignColor: Color = Color.white

# Lifecycle Methods
func _init() -> void:
	Persist.connect("PersistTick", self, "OnGameTick")

func _process(delta: float) -> void:
		position = Vector2.ZERO

# PersistMethods
func Serialize() -> Dictionary:
	return {
		"name": Name,
		"state": State,
		"position": {
			"x": MapPosition.x,
			"y": MapPosition.y
		},
		"resource": {
			"path": ResourcePath
		},
		"design": {
			"color": DesignColor
		},
		"location": {
			"id": LocationID
		},
		"fuel": {
			"destination": Destination,
			"current": CurrentFuel
		}
	}

# Connected Methods
func OnGameTick() -> void:
	if State == Enums.AircraftStates.TRANSIT:
		pass

