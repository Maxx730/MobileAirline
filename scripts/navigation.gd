extends Node

class_name Nav

onready var FleetButton: Button = get_node("ui/frame/contents/buttons/fleet")
onready var ShopButton: Button = get_node("ui/frame/contents/buttons/shop")
onready var MapButton: Button = get_node("ui/frame/contents/buttons/map")

# Lifecycle Methods
func _ready() -> void:
	FleetButton.connect("pressed", self, "OnNavButtonPressed", ["fleet", FleetButton])
	ShopButton.connect("pressed", self, "OnNavButtonPressed", ["shop", ShopButton])
	MapButton.connect("pressed", self, "OnNavButtonPressed", ["map", MapButton])

# Connected Methods
func OnNavButtonPressed(context: String, button) -> void:
	ActivateButtons()
	button.disabled = true
	Events.emit_signal("MainScreenChanged", context)

func ActivateButtons() -> void:
	FleetButton.disabled = false
	ShopButton.disabled = false
	MapButton.disabled = false

# General Methods
func ToggleUI(val: bool = false):
	var ui = get_node("ui")
	if ui:
		ui.visible = val
