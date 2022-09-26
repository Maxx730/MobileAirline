extends PopupDialog

class_name SimpleAlert

# UI ELEMENTS
onready var OkButton: Button = get_node("actions/confirm")
onready var TitleLabel: Label = get_node("top/title")
onready var SubtitleLabel: Label = get_node("top/subtitle")
onready var MessageLabel: Label = get_node("content/message")

# LIFECYCLE METHODS
func _ready() -> void:
	if OkButton:
		OkButton.connect("pressed", self, "OnOkConfirmed")

# CONNECTED METHODS
func OnOkConfirmed() -> void:
	self.queue_free()

# GENERAL METHODS
func SetAlertInformation(title, subtitle, message) -> void:
	if TitleLabel:
		TitleLabel.text = title
	
	if SubtitleLabel:
		SubtitleLabel.text = subtitle
		
	if MessageLabel:
		MessageLabel.text = message
