extends Node2D

class_name LocationDetails

# UI Elements
onready var BackButton = get_node("ui/back/button")

var NextScene

# Lifecycle Methods
func _ready() -> void:
	Transition.TransitionStart(true)
	ConnectButtons()
	NextScene = null
	Transition.connect("OnTransitionOutFinished", self, "OnTransitionOutFinished")

# Connected Methods
func OnBackButtonPressed() -> void:
	NextScene = "res://scenes/screens/menu.tscn"
	Transition.TransitionStart(false)
	
func OnTransitionOutFinished() -> void:
	if NextScene:
		get_tree().change_scene(NextScene)

# Startup Methods
func ConnectButtons() -> void:
	if BackButton:
		BackButton.connect("pressed", self, "OnBackButtonPressed")
