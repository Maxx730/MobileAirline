extends Node

class_name Gameplay

# KEEPS TRACK OF THE GIVEN SCREEN 
# THE PLAYER IS ON AS WELL AS
# THE CONTEXT THE PLAYER IS IN I.E LOADING 
# CARGO WOULD REQUIRE THE SHOP SCREEN
var GameplayState: int = Enums.GameplayScreens.AIRCRAFT
var GameplayContext: int = Enums.GameContext.IDLE

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
	pass

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
				var sprite = Sprite.new()
				sprite.texture = aircraft.DesignTexture
				sprite.name = "aircraft_" + str(Persist.FleetData.find(aircraft))
				sprite.scale = Vector2(2, 2)
				get_node(AircraftDisplayPath).add_child(sprite)
