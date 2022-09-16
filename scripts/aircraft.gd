extends Node2D

class_name Aircraft

##############
# GENERAL    #
##############
var Name = "Generic Airbus"
var State: int = Enums.AircraftStates.LANDED
var LocationID: int = 0

# FUEL
var MaxFuel: int = 100
var CurrentFuel: int = 100
var FuelPerTick: int = 1

##############
# LOGO/COLOR #
##############
var DesignTexture: Texture = preload("res://textures/aircraft/airbus_passenger.png")
var DesignColor: Color = Color.white

# PersistMethods
func Serialize() -> Dictionary:
	return {
		"name": Name,
		"state": State,
		"design": {
			"texture": DesignTexture.resource_path if DesignTexture else null,
			"color": DesignColor
		},
		"location": {
			"id": LocationID
		},
		"fuel": {
			"max": MaxFuel,
			"current": CurrentFuel,
			"tick": FuelPerTick
		}
	}
