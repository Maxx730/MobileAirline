extends Panel

class_name PanelButton

export(bool) var Disabled = false setget SetDisabled

signal PanelButtonPressed()

# Lifecycle Methods
func _ready() -> void:
	FormatDisabled(Disabled)

func _gui_input(event: InputEvent) -> void:
	if !Disabled:
		if event is InputEventMouseButton:
			if event.pressed and event.button_index == BUTTON_LEFT:
				emit_signal("PanelButtonPressed")

# Setter Methods
func SetDisabled(disabled: bool) -> void:
	Disabled = disabled
	FormatDisabled(disabled)

# General Methods
func FormatDisabled(disabled) -> void:
	if get_child_count() > 0:
		get_child(0).modulate = Color(1, 1, 1, 0.25) if disabled else Color.white
		mouse_default_cursor_shape = CURSOR_FORBIDDEN if disabled else CURSOR_POINTING_HAND
	
