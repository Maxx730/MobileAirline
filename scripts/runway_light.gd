tool
extends Node2D

class_name RunwayLight

const BULB_INTENSITY = 0.5

export(bool) var IsOn = true
export(bool) var Flashing = false setget SetFlashing
export(float, 0.1, 1.0) var FlashLength = 0.5
export(Color) var LightColor = Color.white setget SetSourceColor

onready var Source: Light2D = get_node("light")

var LastFlashChange = 0

# LifeCycle Methods
func _process(delta: float) -> void:
	if Flashing:
		LastFlashChange += delta
		if LastFlashChange >= FlashLength:
			if get_node("light"):
				get_node("light").visible = !get_node("light").visible
				LastFlashChange = 0

# General Methods

# Editor Methods
func SetSourceColor(color) -> void:
	if get_node("light") and get_node("bulb"):
		LightColor = color
		get_node("light").color = color
		get_node("bulb").modulate = Color(color.r + BULB_INTENSITY, color.g + BULB_INTENSITY, color.b + BULB_INTENSITY, color.a)

func SetFlashing(flashing: bool) -> void:
	Flashing = flashing
	LastFlashChange = 0
	if get_node("light"):
		get_node("light").enabled = IsOn
