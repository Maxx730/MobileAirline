extends Node

class_name Menu

onready var NewGameButton: PanelButton = get_node("ui/main_menu/list/top/begin")
onready var ContinueGameButton: PanelButton = get_node("ui/main_menu/list/top/continue")
onready var SettingsButton: PanelButton = get_node("ui/main_menu/list/top/settings")
onready var ErrorMessage: Panel = get_node("ui/main_menu/list/error_panel")

# Debug Elements
onready var WorldGenerationButton: PanelButton = get_node("ui/main_menu/list/debug/options/worldgen")
onready var LocationDetailsButton: PanelButton = get_node("ui/main_menu/list/debug/options/location_details")
onready var DetailsButton: PanelButton = get_node("ui/main_menu/list/debug/options/details")


var NextScene

# Lifecycle Methods
func _ready() -> void:
	Persist.connect("PersistLoadError", self, "OnPersistError")
	
	ConnectButtons()
	Transition.connect("OnTransitionInFinished", self, "OnTransitionInFinished")
	Transition.connect("OnTransitionOutFinished", self, "OnTransitionOutFinished")
	Transition.TransitionStart(true)
	
	if Data.DataExists():
		Persist.Load()
		ModifyContinueLayout(false)

# Setup Methods
func ConnectButtons() -> void:
	if NewGameButton:
		NewGameButton.connect("PanelButtonPressed", self, "OnNewGamePressed")
		
	if ContinueGameButton:
		ContinueGameButton.connect("PanelButtonPressed", self, "OnContinueGamePressed")
		
	if SettingsButton:
		SettingsButton.connect("PanelButtonPressed", self, "OnSettingsButtonPressed")
		
	if WorldGenerationButton:
		WorldGenerationButton.connect("PanelButtonPressed", self, "OnWorldGenPressed")
	
	if LocationDetailsButton:
		LocationDetailsButton.connect("PanelButtonPressed", self, "OnLocationDetailsPressed")
		
	if DetailsButton:
		DetailsButton.connect("PanelButtonPressed", self, "OnDetailsButtonPressed")

func ModifyContinueLayout(newGame: bool = true) -> void:
	if !newGame:
		if NewGameButton:
			NewGameButton.visible = false
			
		if ContinueGameButton:
			ContinueGameButton.visible = true

# Connected Methods
func OnNewGamePressed() -> void:
	Transition.TransitionStart(false)
	NextScene = "res://scenes/screens/begin.tscn"
	
func OnContinueGamePressed() -> void:
	NextScene = "res://scenes/screens/gameplay.tscn"
	Transition.TransitionStart(false)

func OnSettingsButtonPressed() -> void:
	Transition.TransitionStart(false)
	NextScene = "res://scenes/screens/settings.tscn"

func OnDetailsButtonPressed() -> void:
	Transition.TransitionStart(false)
	NextScene = "res://scenes/screens/details.tscn"

func OnPersistError() -> void:
	if ErrorMessage:
		ErrorMessage.visible = true

func OnWorldGenPressed() -> void:
	Transition.TransitionStart(false)
	NextScene = "res://scenes/test/shader_overworld.tscn"

func OnTransitionInFinished() -> void:
	NextScene = null

func OnTransitionOutFinished() -> void:
	if NextScene:
		print("Changing to scene: " + NextScene)
		get_tree().change_scene(NextScene)

func OnLocationDetailsPressed() -> void:
	Transition.TransitionStart(false)
	NextScene = "res://scenes/screens/location.tscn"
