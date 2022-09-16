extends Panel

class_name ColorChoice

signal OnColorPressed(color, element)

var ColorValue: Color
var ChoiceStyle: StyleBoxFlat

# Lifecycle Methods
func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_LEFT:
			emit_signal("OnColorPressed", ColorValue, self)

# Startup Methods
func SetColor(color: Color) -> void:
	var colorStyle = StyleBoxFlat.new()
	colorStyle.bg_color = Color(color.r, color.g, color.b, 1.0)
	colorStyle.border_color = Color.white
	ChoiceStyle = colorStyle
	add_stylebox_override("panel", colorStyle)
	ColorValue = color

# General Methods
func SetChoiceSelected(selected: bool) -> void:
	if ChoiceStyle:
		ChoiceStyle.border_width_bottom = 2 if selected else 0
		ChoiceStyle.border_width_top = 2 if selected else 0
		ChoiceStyle.border_width_left = 2 if selected else 0
		ChoiceStyle.border_width_right = 2 if selected else 0
