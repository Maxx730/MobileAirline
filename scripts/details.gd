extends Screen

class_name Details

onready var FocusedAircraftName: Label = get_node("ui/interface/title/list/name")
onready var FocusedAircraftCallSign: Label = get_node("ui/interface/title/list/callsign")
onready var FleetList: Node = get_node("aircraft/fleet")
onready var BackdropList: Node2D = get_node("backdrops/backgrounds")

#####################
# LIFECYCLE METHODS #
#####################
func _ready() -> void:
	Events.connect("AircraftChanged", self, "OnFocusedAircraftChanged")
	Events.connect("AircraftSpawned", self, "HideAllAircraft")
	Events.connect("ContextChanged", self, "OnGameplayContextChange")
	
#####################
# CONNECTED METHODS #
#####################
func OnFocusedAircraftChanged(id: int) -> void:
	var craft: Aircraft = Persist.FleetData[id]
	UpdateDetailUI(craft)
	ShowAircraft(id)
	ShowBackdrop(
		GetBackdropBasedOnState(craft.State)	
	)

func OnGameplayContextChange(context) -> void:
	if context == Enums.GameContext.IDLE:
		ShowAircraft(0)
		ShowBackdrop(
			GetBackdropBasedOnState(Persist.FleetData[0].State)
		)
	else:
		HideAllBackdrops()

###################
# GENERAL METHODS #
###################
func UpdateDetailUI(aircraft: Aircraft) -> void:
	if FocusedAircraftName:
		FocusedAircraftName.text = aircraft.Name
		
	if FocusedAircraftCallSign:
		var words = aircraft.Name.split(" ")
		var after = ""
		for word in words:
			if word is String:
				after += word[0]
		FocusedAircraftCallSign.text = Persist.AirlineCallSign + "-" + after

####################
# AIRCRAFT METHODS #
####################
func HideAllAircraft() -> void:
	for aircraft in FleetList.get_children():
		aircraft.visible = false

func ShowAircraft(id: int = 0) -> void:
	HideAllAircraft()
	if FleetList.get_child_count() > id:
		FleetList.get_child(id).visible = true

####################
# BACKDROP METHODS #
####################
func HideAllBackdrops() -> void:
	for backdrop in BackdropList.get_children():
		backdrop.visible = false
		if backdrop is Backdrop:
			backdrop.HideContents()

func ShowBackdrop(id: int = 0):
	HideAllBackdrops()
	if id < BackdropList.get_child_count():
		var backdrop = BackdropList.get_child(id)
		backdrop.visible = true
		if backdrop is Backdrop:
			backdrop.ShowContents()

func GetBackdropBasedOnState(state) -> int:
	return state
