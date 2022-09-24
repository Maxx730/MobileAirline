extends Node

class_name Cargo

var Description: String = "Undefined"
var Destination: int = -1
var Value: int = 1

# PERSIST METHODS
func Serialize() -> Dictionary:
	return {
		"description": Description,
		"destination": Destination,
		"value": Value
	}
