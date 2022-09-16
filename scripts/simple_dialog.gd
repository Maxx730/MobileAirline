extends PopupDialog

class_name SimpleDialog

# action buttons
onready var ConfirmButton: Button = get_node("actions/confirm")
onready var CancelButton: Button = get_node("actions/cancel")

# info labels
onready var TitleLabel: Label = get_node("top/title")
onready var SubtitleLabel: Label = get_node("top/subtitle")
onready var MessageLabel: Label = get_node("content/message")

signal OnDialogConfirm()
signal OnDialogCancel()

# Lifecycle Methods
func _ready() -> void:
	ConnectActions()

# Startup Methods
func ConnectActions() -> void:
	if ConfirmButton:
		ConfirmButton.connect("pressed", self, "OnConfirmClicked")
		
	if CancelButton:
		CancelButton.connect("pressed", self, "OnCancelClicked")

# General Methods
func SetDialogInformation(title, subtitle, message) -> void:
	if TitleLabel:
		TitleLabel.text = title
	
	if SubtitleLabel:
		SubtitleLabel.text = subtitle
		
	if MessageLabel:
		MessageLabel.text = message

# Connected Methods
func OnConfirmClicked() -> void:
	emit_signal("OnDialogConfirm")
	self.queue_free()
	
func OnCancelClicked() -> void:
	emit_signal("OnDialogCancel")
	self.queue_free()
