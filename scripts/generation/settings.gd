extends Control

class_name GenerationSettings

onready var LacunarityLabel: Label = get_node("list/lacunarity/label")
onready var LacunaritySlider: Slider = get_node("list/lacunarity/value")

onready var PersistenceLabel: Label = get_node("list/persistence/label")
onready var PersistenceSlider: Slider = get_node("list/persistence/value")

onready var OctavesLabel: Label = get_node("list/octaves/label")
onready var OctavesSlider: Slider = get_node("list/octaves/value")

#####################
# LIFECYCLE METHODS #
#####################
func _ready() -> void:
	if LacunaritySlider:
		LacunaritySlider.connect("drag_ended", self, "OnLacunarityChanged")
		
	if PersistenceSlider:
		PersistenceSlider.connect("drag_ended", self, "OnPersistenceChanged")
		
	if OctavesSlider:
		OctavesSlider.connect("drag_ended", self, "OnOctavesChanged")
		
#####################
# CONNECTED METHODS #
#####################
func OnLacunarityChanged(value) -> void:
	Persist.MapLacunarity = LacunaritySlider.value

func OnPersistenceChanged(value) -> void:
	Persist.MapPersistence = PersistenceSlider.value
	
func OnOctavesChanged(value) -> void:
	Persist.MapOctaves = OctavesSlider.value
