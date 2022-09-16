extends Screen

class_name Fleet

onready var LeftButton: Button = get_node("ui/details/details/contents/actions/buttons/left")
onready var RightButton: Button = get_node("ui/details/details/contents/actions/buttons/right")
onready var CargoButton: Button = get_node("ui/details/details/contents/actions/buttons/cargo")
onready var DepartButton: Button = get_node("ui/details/details/contents/actions/buttons/depart")
onready var AircraftHolder: Node2D = get_node("graphics/aircraft")


# Lifecycle Methods
func _ready() -> void:
	Events.connect("OverworldInitialized", self, "OnOverworldGenerated")

func _process(delta) -> void:
	pass

# Connected Methods
func OnOverworldGenerated(FirstGen) -> void:
	print("Initializing Fleet...")
	if FirstGen:
		# Spawn in the default aircraft
		pass
	
