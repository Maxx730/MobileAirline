extends Node

class_name Gameplay

###########
# SCREENS #
###########
onready var GameplayScreens: Screens = get_node("screens")
onready var GameplayControls: Controls = get_node("controls")

export(NodePath) var AircraftDisplayPath

#####################
# LIFECYCLE METHODS #
#####################
func _ready() -> void:
	Events.connect("ContextChanged", self, "OnContextChanged")
	Persist.connect("PersistDataLoaded", self, "PersistDataLoaded")
	Persist.Load()
		
#####################
# CONNECTED METHODS #
#####################
func PersistDataLoaded() -> void:
	Transition.TransitionStart(true)
	if GameplayScreens:
		SpawnFleetData(Persist.FleetData)
		GameplayScreens.ShowScreen(0)
		Events.emit_signal("AircraftChanged", 0)

func OnContextChanged(context) -> void:
	State.GameplayContext = context

#####################
# GENERAL METHODS   #
#####################

#####################
# SPAWN METHODS     #
#####################
func SpawnFleetData(aircraftData: Array) -> void:
	if AircraftDisplayPath and get_node(AircraftDisplayPath):
		for aircraft in aircraftData:
			if aircraft is Aircraft:
				var craft: Aircraft = load(aircraft.ResourcePath).instance()
				craft.position = Vector2.ZERO
				get_node(AircraftDisplayPath).add_child(aircraft)

	Events.emit_signal("AircraftSpawned")
