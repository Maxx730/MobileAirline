extends Node

class_name SettingsUI

onready var BackButton: TextureButton = get_node("ui/frame/title/hor/back/back")
onready var ClearButton: PanelButton = get_node("ui/frame/list/clear_data")
onready var DynamicDayCheck: CheckBox = get_node("ui/frame/list/daylight/content/check/value")
onready var ApplySettingsButton: Button = get_node("ui/frame/list/actions/buttons/apply")

var ShouldSave: bool = false

# Lifecycle Methods
func _ready() -> void:
	Transition.TransitionStart(true)
	Transition.connect("OnTransitionOutFinished", self, "OnTransitionBackFinished")
	
	# 
	if Settings.SettingsExists():
		Settings.Load()
		if ClearButton and Data.DataExists():
			ClearButton.Disabled = false
			ClearButton.FormatDisabled(ClearButton.Disabled)
	else:
		Settings.Save()
	
	ApplyStoredSettings(
		Settings.SETTINGS_OBJECT
	)
	ConnectButtons()
	
# Setup Methods
func ConnectButtons() -> void:
	BackButton.connect("pressed", self, "BackToMain")
	ClearButton.connect("PanelButtonPressed", self, "ClearDataPressed")
	DynamicDayCheck.connect("pressed", self, "OnDynamicLightChange")
	ApplySettingsButton.connect("pressed", self, "OnApplyButtonPressed")

func ApplyStoredSettings(settings: Dictionary) -> void:
	if DynamicDayCheck and settings.has("use_dynamic_light"):
		DynamicDayCheck.pressed = settings.use_dynamic_light
		
	if ClearButton:
		pass

# Connected Methods
func BackToMain() -> void:
	Transition.TransitionStart(false)

func ClearDataPressed() -> void:
	var clearDialog: SimpleDialog = GlobalDialog.CreateDialog("Clear Saved Data?", "Deletes currently saved data.", "Are you sure you would like to delete the currently saved game? This will erase all data and CANNOT be undone.", get_node("ui"))
	clearDialog.connect("OnDialogConfirm", self, "OnClearDataConfirm")

func OnDynamicLightChange() -> void:
	if Settings.SETTINGS_OBJECT.has("use_dynamic_light"):
		Settings.SETTINGS_OBJECT.use_dynamic_light = !Settings.SETTINGS_OBJECT.use_dynamic_light
	ShouldSave = true
	UpdateApplyButton()

func OnApplyButtonPressed() -> void:
	ShouldSave = false
	Settings.Save()
	UpdateApplyButton()

func OnTransitionBackFinished() -> void:
	get_tree().change_scene("res://scenes/screens/menu.tscn")

func OnClearDataConfirm() -> void:
	ClearButton.Disabled = true
	ClearButton.FormatDisabled(true)
	Data.ClearData()
	Persist.Clear()

# General Methods
func UpdateApplyButton() -> void:
	if ApplySettingsButton:
		ApplySettingsButton.disabled = !ShouldSave
