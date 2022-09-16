extends Node2D

class_name WorldGen

onready var WorldCamera: Camera2D = get_node("camera")
onready var ZoomInButton: Button = get_node("frame/interface/zoom/actions/in")
onready var ZoomOutButton: Button = get_node("frame/interface/zoom/actions/out")
onready var WorldMapSprite: Sprite = get_node("frame/map")
onready var RandomizeValuesButton: Button = get_node("frame/interface/debug/randomize")
onready var ExitButton: Button = get_node("frame/interface/debug/exit/exit")

# Debug Elements
onready var DebugSeedLabel: Label = get_node("frame/interface/debug/list/seed")
onready var DebugZoomLabel: Label = get_node("frame/interface/debug/list/zoom")

var WorldGenNoise: OpenSimplexNoise
var IsMouseDown: bool = false

# Lifecycle Methods
func _ready() -> void:
	WorldGenNoise = WorldMapSprite.texture.noise as OpenSimplexNoise
	Transition.TransitionStart(true)
	Transition.connect("OnTransitionOutFinished", self, "OnTransitionOutEnd")
	SetDebugInformation()
	
	# Connect Debug Elements
	if RandomizeValuesButton:
		RandomizeValuesButton.connect("pressed", self, "OnRandomizeButtonPressed")
		
	if ExitButton:
		ExitButton.connect("pressed", self, "OnExitButtonPressed")
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			IsMouseDown = event.pressed
			
	if IsMouseDown and event is InputEventMouseMotion:
		if WorldCamera:
			WorldCamera.position -= event.relative / 2

# General Methods
func SetDebugInformation() -> void:
	if WorldGenNoise:
		if DebugSeedLabel:
			DebugSeedLabel.text = "SEED: " + str(WorldGenNoise.seed)
	
	if WorldCamera:
		if DebugZoomLabel:
			DebugZoomLabel.text = "ZOOM: " + str(WorldCamera.zoom)

# Connected Methods
func OnRandomizeButtonPressed() -> void:
	randomize()
	var randomSeed = randi()
	WorldGenNoise.seed = randomSeed
	SetDebugInformation()

func OnExitButtonPressed() -> void:
	Transition.TransitionStart(false);

func OnTransitionOutEnd() -> void:
	get_tree().change_scene("res://scenes/screens/menu.tscn")
