extends Node2D

class_name Aircraft

##############
# GENERAL    #
##############
var Name = "Generic Airbus"
var State: int = Enums.AircraftStates.LANDED
var LocationID: int = 0
var ResourcePath: String
var MapPosition: Vector2

#########
# FUEL  #
#########
var Destination: int = -1
var MaxFuel: float = 100.0
var CurrentFuel: float = 100.0
var FuelPerTick: float = 1.0
var SpeedPerTick: int = 1

##############
# LOGO/COLOR #
##############
var DesignColor: Color = Color.white

# Lifecycle Methods
func _init() -> void:
	Persist.connect("PersistTick", self, "OnGameTick")

func _process(delta: float) -> void:
	if State == Enums.AircraftStates.TRANSIT:
		position = Vector2(
				cos(OS.get_unix_time() * 2.5) * 150 * delta,
				0
			)
	else:
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
			"max": MaxFuel,
			"current": CurrentFuel,
			"tick": FuelPerTick
		}
	}

# Connected Methods
func OnGameTick() -> void:
	if State == Enums.AircraftStates.TRANSIT:
		CurrentFuel -= FuelPerTick
		CurrentFuel = clamp(CurrentFuel, 0, MaxFuel)

