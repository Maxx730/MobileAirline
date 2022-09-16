extends Control

class_name SimpleSwitcher

onready var PreviousButton: Button = get_node("background/actions/left")
onready var NextButton: Button = get_node("background/actions/right")

# Signals
signal OnPreviousPressed()
signal OnNextPressed()
signal OnArrowPressed(isNext)

# Lifecycle Methods
func _ready() -> void:
	ConnectButtons()

# Setup Methods
func ConnectButtons() -> void:
	if PreviousButton:
		PreviousButton.connect("pressed", self, "OnPreviousButtonPressed")
	
	if NextButton:
		NextButton.connect("pressed", self, "OnNextButtonPressed")

# Connected Methods
func OnPreviousButtonPressed() -> void:
	emit_signal("OnPreviousPressed")
	emit_signal("OnArrowPressed", false)

func OnNextButtonPressed() -> void:
	emit_signal("OnNextPressed")
	emit_signal("OnArrowPressed", true)
