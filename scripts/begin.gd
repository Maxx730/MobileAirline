extends Node

# Dialog Elements
onready var SureDialog: PopupDialog = get_node("ui/sure")
onready var DialogConfirmButton: Button = get_node("ui/sure/actions/confirm")
onready var DialogCancelButton: Button = get_node("ui/sure/actions/cancel")

# General Elements
onready var CancelButton: Button = get_node("ui/main_menu/list/options/cancel")
onready var BeginButton: Button = get_node("ui/main_menu/list/options/begin")
onready var NewAirlineName: LineEdit = get_node("ui/main_menu/list/details/name")
onready var NewAirlineCallSign: LineEdit = get_node("ui/main_menu/list/details/call_sign")

var NextScene

# Lifecycle Methods
func _ready() -> void:
	Transition.TransitionStart(true)
	Transition.connect("OnTransitionOutFinished", self, "OnTransitionOutFinished")
	ConnectButtons()
	
# Startup Methods
func ConnectButtons() -> void:
	if CancelButton:
		CancelButton.connect("pressed", self, "OnCancelPressed")
	
	if BeginButton:
		BeginButton.connect("pressed", self, "OnBeginPressed")
		
	if NewAirlineName:
		NewAirlineName.connect("text_changed", self, "OnAirlineNameEntered")
		
	if NewAirlineCallSign:
		NewAirlineCallSign.connect("text_changed", self, "OnAirlineCallsignEntered")

# Connected Methods
func OnCancelPressed() -> void:
	NextScene = "res://scenes/screens/menu.tscn"
	Transition.TransitionStart(false)

func OnBeginPressed() -> void:
	Persist.AirlineName = NewAirlineName.text
	Persist.AirlineCallSign = NewAirlineCallSign.text
	Persist.Save()
	# Change to loading screen
	get_tree().change_scene("res://scenes/screens/loading.tscn")

func OnTransitionOutFinished() -> void:
	if NextScene != null:
		get_tree().change_scene(NextScene)

func OnAirlineNameEntered(name) -> void:
	ApplyButtonCheck()
	
func OnAirlineCallsignEntered(callsign: String) -> void:
	NewAirlineCallSign.text = callsign.to_upper()
	ApplyButtonCheck()

# General Methods
func ApplyButtonCheck() -> void:
	if BeginButton:
		BeginButton.disabled = !(NewAirlineName.text != "" and NewAirlineCallSign.text != "")
