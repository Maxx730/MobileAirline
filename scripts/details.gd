extends Screen

class_name Details

onready var FocusedAircraftName: Label = get_node("ui/interface/title/list/name")
onready var FocusedAircraftCallSign: Label = get_node("ui/interface/title/list/callsign")

#####################
# LIFECYCLE METHODS #
#####################
func _ready() -> void:
	Events.connect("AircraftChanged", self, "OnFocusedAircraftChanged")
	
#####################
# CONNECTED METHODS #
#####################
func OnFocusedAircraftChanged(id: int) -> void:
	var craft = Persist.FleetData[id]
	UpdateDetailUI(craft)

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
