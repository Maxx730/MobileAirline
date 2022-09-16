extends Node

class_name Controls

onready var FocusedButtons: Control = get_node("ui/bottom")
onready var BackPanelButton: PanelButton = get_node("ui/back")

onready var NextButton: Button = get_node("ui/bottom/switcher/buttons/next")
onready var PreviousButton: Button = get_node("ui/bottom/switcher/buttons/prev")
onready var SettingsButton: PanelButton = get_node("ui/top/settings")
onready var ShopButton: PanelButton = get_node("ui/bottom/shop")
onready var MapButton: PanelButton = get_node("ui/bottom/map")
onready var BackButton: PanelButton = get_node("ui/back")

var FocusedAircraft: int = 0
var NextScene = null

#####################
# LIFECYCLE METHODS #
#####################
func _ready() -> void:
	if SettingsButton:
		SettingsButton.connect("PanelButtonPressed", self, "OnSettingsButtonPressed")
	
	if NextButton:
		NextButton.connect("pressed", self, "OnNextAircraftPressed")
		
	if PreviousButton:
		PreviousButton.connect("pressed", self, "OnPreviousAircraftPressed")
	
	if ShopButton:
		ShopButton.connect("PanelButtonPressed", self, "OnShopButtonPressed")
		
	if MapButton:
		MapButton.connect("PanelButtonPressed", self, "OnMapButtonPressed")
	
	if BackButton:
		BackButton.connect("PanelButtonPressed", self, "OnBackButtonPressed")
	
	Events.connect("ContextChanged", self, "OnContextChanged")
	Transition.connect("OnTransitionOutFinished", self, "OnTransitionOutFinished")

#####################
# GENERAL METHODS #
#####################
func UpdateControls(context) -> void:
	var showBack: bool = context == Enums.GameContext.SHOP || context == Enums.GameContext.MAP
	BackPanelButton.visible = showBack
	FocusedButtons.visible = !showBack


#####################
# CONNECTED METHODS #
#####################
func OnNextAircraftPressed() -> void:
	if FocusedAircraft  + 1 < Persist.FleetData.size():
		FocusedAircraft += 1
	else:
		FocusedAircraft = 0
		
	Events.emit_signal("AircraftChanged", FocusedAircraft)
	
func OnPreviousAircraftPressed() -> void:
	if FocusedAircraft > 0:
		FocusedAircraft -= 1
	else:
		FocusedAircraft = Persist.FleetData.size() - 1
		
	Events.emit_signal("AircraftChanged", FocusedAircraft)

func OnSettingsButtonPressed() -> void:
	NextScene = "res://scenes/screens/settings.tscn"
	Transition.TransitionStart(false)

func OnShopButtonPressed() -> void:
	Events.emit_signal("ContextChanged", Enums.GameContext.SHOP)

func OnMapButtonPressed() -> void:
	Events.emit_signal("ContextChanged", Enums.GameContext.MAP)

func OnBackButtonPressed() -> void:
	Events.emit_signal("ContextChanged", Enums.GameContext.IDLE)

func OnTransitionOutFinished() -> void:
	if NextScene != null:
		get_tree().change_scene(NextScene)

func OnContextChanged(context) -> void:
	UpdateControls(context)
