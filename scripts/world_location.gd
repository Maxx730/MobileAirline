extends Area2D

class_name WorldLocation

export(float) var AnimationSpeed: float = 0.5

onready var TowerIcon: Sprite = get_node("icon")
onready var LockIcon: Sprite = get_node("lock")

var LocationRef: Location

signal OnLocationPressed(id)

#####################
# LIFECYCLE METHODS #
#####################
func _ready() -> void:
	connect("input_event", self, "OnLocationButtonPressed")
	UpdateUI()
	
# GENERAL METHODS
func GetLocationIcon() -> TextureRect:
	return get_node("icon") as TextureRect

func GetLocationLabel() -> Label:
	return get_node("name") as Label

func OnLocationButtonPressed(viewport, event, shape) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_LEFT:
			emit_signal("OnLocationPressed", LocationRef.ID)

func SetUIElements(name) -> void:
	if get_node("name"):
		get_node("name").text = name

# UI METHODS
func UpdateUI() -> void:
	if LockIcon:
		LockIcon.visible = !LocationRef.Unlocked

	if TowerIcon and !LocationRef.Unlocked:
		TowerIcon.modulate = Color(1, 1, 1, 0.25)
