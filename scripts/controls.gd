extends Node

class_name Controls

onready var FocusedButtons: Control = get_node("ui/frame/bottom")
onready var BackPanelButton: PanelButton = get_node("ui/frame/back")

onready var NextButton: Button = get_node("ui/frame/bottom/switcher/buttons/next")
onready var PreviousButton: Button = get_node("ui/frame/bottom/switcher/buttons/prev")
onready var SettingsButton: PanelButton = get_node("ui/frame/head/settings")
onready var ShopButton: PanelButton = get_node("ui/frame/bottom/shop")
onready var MapButton: PanelButton = get_node("ui/frame/bottom/map")
onready var BackButton: PanelButton = get_node("ui/frame/back")
onready var DepartButton: Button = get_node("ui/frame/bottom/switcher/buttons/depart")
onready var GlobalPanel: Panel = get_node("ui/frame/global")

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
	
	if DepartButton:
		DepartButton.connect("pressed", self, "OnDepartPressed")
	
	Events.connect("ContextChanged", self, "OnContextChanged")
	Events.connect("AircraftChanged", self, "UpdateAircraftControls")
	Transition.connect("OnTransitionOutFinished", self, "OnTransitionOutFinished")

###################
# GENERAL METHODS #
###################
func UpdateControls(context) -> void:
	var showBack: bool = context == Enums.GameContext.SHOP or context == Enums.GameContext.MAP or context == Enums.GameContext.CHOOSE_DESTINATION
	BackPanelButton.visible = showBack
	FocusedButtons.visible = !showBack
	GlobalPanel.visible = !showBack

func UpdateAircraftControls(id) -> void:
	var state: int = Persist.FleetData[id].State
	if DepartButton:
		DepartButton.disabled = state == Enums.AircraftStates.TRANSIT

func EmitAircraftChange() -> void:
	Events.emit_signal("AircraftChanged", State.FocusedAircraft)

func EmitChangeToMap() -> void:
	Events.emit_signal("ContextChanged", Enums.GameContext.MAP)
	
func EmitIdleChange() -> void:
	Events.emit_signal("ContextChanged", Enums.GameContext.IDLE)

func EmitShopChange() -> void:
	Events.emit_signal("ContextChanged", Enums.GameContext.SHOP)

func EmitDepartChange() -> void:
	var aircraft: Aircraft = Persist.FleetData[State.FocusedAircraft]
	if aircraft:
		Events.emit_signal("ContextChanged", Enums.GameContext.CHOOSE_DESTINATION)

#####################
# CONNECTED METHODS #
#####################
func OnNextAircraftPressed() -> void:
	if State.FocusedAircraft  + 1 < Persist.FleetData.size():
		State.FocusedAircraft += 1
	else:
		State.FocusedAircraft = 0
		
	var changeAircraft: FuncRef = funcref(self, "EmitAircraftChange")
	Transition.QuickTransition(changeAircraft)
	
func OnPreviousAircraftPressed() -> void:
	if State.FocusedAircraft > 0:
		State.FocusedAircraft -= 1
	else:
		State.FocusedAircraft = Persist.FleetData.size() - 1
		
	var changeAircraft: FuncRef = funcref(self, "EmitAircraftChange")
	Transition.QuickTransition(changeAircraft)

func OnSettingsButtonPressed() -> void:
	NextScene = "res://scenes/screens/settings.tscn"
	Transition.TransitionStart(false)
	Persist.ShouldTick = false

func OnShopButtonPressed() -> void:
	var shopRef: FuncRef = funcref(self, "EmitShopChange")
	Transition.QuickTransition(shopRef)

func OnMapButtonPressed() -> void:
	var changeToMap: FuncRef = funcref(self, "EmitChangeToMap")
	Transition.QuickTransition(changeToMap)

func OnBackButtonPressed() -> void:
	var idleRef: FuncRef = funcref(self, "EmitIdleChange")
	Transition.QuickTransition(idleRef)

func OnTransitionOutFinished() -> void:
	if NextScene != null:
		get_tree().change_scene(NextScene)

func OnContextChanged(context) -> void:
	UpdateControls(context)
	UpdateAircraftControls(0)

func OnDepartPressed() -> void:
	var departRef: FuncRef = funcref(self, "EmitDepartChange")
	Transition.QuickTransition(departRef)
