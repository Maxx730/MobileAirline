extends Screen

class_name Resume

onready var ResumeLabel: Label = get_node("ui/resume_message")

# Lifecycle Methods
func _ready() -> void:
	Events.connect("SetResumeMessage", self, "OnResumeMessageChanged")
	
# Connected Methods
func OnResumeMessageChanged(message: String) -> void:
	if ResumeLabel:
		ResumeLabel.text = message
