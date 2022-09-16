extends Panel

class_name SimpleLogoPicker

export(Array, Texture) var AvailableLogos

onready var NextLogoButton: Button = get_node("vert/next")
onready var PreviousLogoButton: Button = get_node("vert/previous")
onready var LogoIcon: TextureRect = get_node("vert/logo/background/logo")
onready var ColorPick: SimpleColorPicker = get_node("../simple_color_picker")

var LogoIndex = 0

# Lifecycle Methods
func _ready() -> void:
	InitializeLogo()
	if ColorPick:
		ColorPick.connect("ColorChoiceSelected", self, "ChangeLogoColor")
		
	if NextLogoButton:
		NextLogoButton.connect("pressed", self, "OnNextLogoPressed")
		
	if PreviousLogoButton:
		PreviousLogoButton.connect("pressed", self, "OnPreviousLogoPressed")

# Setup Methods
func InitializeLogo() -> void:
	if LogoIcon and AvailableLogos.size() > 0:
		SetAirlineLogo(LogoIndex)
		LogoIcon.modulate = Color.gray

# Connected Methods
func ChangeLogoColor(color) -> void:
	if LogoIcon:
		LogoIcon.modulate = color

func OnNextLogoPressed() -> void:
	if LogoIndex + 1 > AvailableLogos.size() - 1:
		LogoIndex = 0
	else:
		LogoIndex += 1
	
	SetAirlineLogo(LogoIndex)
			
func OnPreviousLogoPressed() -> void:
	if LogoIndex - 1 < 0:
		LogoIndex = AvailableLogos.size() - 1
	else:
		LogoIndex -= 1
		
	SetAirlineLogo(LogoIndex)

# General Methods
func SetAirlineLogo(index: int) -> void:
	LogoIcon.texture = AvailableLogos[index]
	Persist.AirlineLogo = LogoIcon.texture.resource_path
