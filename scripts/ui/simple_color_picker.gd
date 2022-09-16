extends Panel

class_name SimpleColorPicker

var ColorChoiceTemplate: PackedScene = preload("res://scenes/prefabs/ui/color_choice.tscn")
export(Array, Color) var SelectableColors
export(Vector2) var ColorChoiceSize = Vector2(32, 32)

signal ColorChoiceSelected(color)

onready var ColorChoices: GridContainer = get_node("colors")

var AllChoices: Array = Array()
var CurrentChoice: Color = Color.white

# Lifecycle Methods
func _ready() -> void:
	InitializeColorChoices()
	
# Setup Methods
func InitializeColorChoices() -> void:
	for color in SelectableColors:
		ColorChoices.add_child(CreateColorPanel(color))
	
	CurrentChoice = SelectableColors[0]
	if ColorChoices.get_child_count() > 0:
		var firstChoice = ColorChoices.get_child(0) as ColorChoice
		firstChoice.SetChoiceSelected(true)

# General Methods
func CreateColorPanel(color: Color) -> Panel:
	var colorPanel = ColorChoiceTemplate.instance() as ColorChoice
	
	colorPanel.SetColor(color)
	colorPanel.connect("OnColorPressed", self, "OnColorChoiceSelected")
	
	AllChoices.append(colorPanel)
	return colorPanel

func GetColor() -> Color:
	return CurrentChoice

# Connected Methods
func OnColorChoiceSelected(color, element) -> void:
	for choice in AllChoices:
		choice.SetChoiceSelected(false)
	
	if element is ColorChoice:
		element.SetChoiceSelected(true)
		CurrentChoice = element.ColorValue
		emit_signal("ColorChoiceSelected", color)
		Persist.AirlineColor = color
		
