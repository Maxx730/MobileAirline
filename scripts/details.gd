extends Screen

class_name Details

onready var FocusedAircraftName: Label = get_node("ui/interface/title/list/name")
onready var FocusedAircraftCallSign: Label = get_node("ui/interface/title/list/callsign")
onready var FocusedAircraftContext: Label = get_node("ui/interface/title/list/location")
onready var FleetList: Node = get_node("aircraft/fleet")
onready var BackdropList: Node2D = get_node("backdrops/backgrounds")

# Aircraft Information Elements
onready var FuelBar: ProgressBar = get_node("ui/interface/info/list/fuel/value")

#####################
# LIFECYCLE METHODS #
#####################
func _ready() -> void:
	Events.connect("AircraftChanged", self, "OnFocusedAircraftChanged")
	Events.connect("AircraftSpawned", self, "HideAllAircraft")
	Events.connect("ContextChanged", self, "OnGameplayContextChange")
	Persist.connect("PersistTick", self, "WorldTick")
	
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
	UpdateAircraftInfo()

func OnGameplayContextChange(context) -> void:
	if context == Enums.GameContext.IDLE:
		ShowAircraft(State.FocusedAircraft)
		ShowBackdrop(
			GetBackdropBasedOnState(Persist.FleetData[State.FocusedAircraft].State)
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

	if FocusedAircraftContext:
		if aircraft.State == Enums.AircraftStates.TRANSIT:
			if aircraft.Destination > -1:
				var dest = Persist.GetLocationFromLocationId(aircraft.Destination)
				FocusedAircraftContext.text = "In Transit to " + dest.Name
		else:
			var location = Persist.GetLocationFromLocationId(aircraft.LocationID)
			FocusedAircraftContext.text = "Landed in " + location.Name

func WorldTick() -> void:
	UpdateAircraftInfo()

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

func UpdateAircraftInfo() -> void:
	var aircraft: Aircraft = Persist.FleetData[State.FocusedAircraft]
	if FuelBar:
		FuelBar.max_value = aircraft.MaxFuel
		FuelBar.value = aircraft.CurrentFuel
	
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
