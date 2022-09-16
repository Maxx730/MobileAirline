extends Node

class_name Screens

onready var GameplayRef = get_parent()

# Lifecycle Methods
func _ready() -> void:
	Events.connect("ContextChanged", self, "OnContextChanged")

# General Methods
func HideAllScreens() -> void:
	for child in get_children():
		child.visible = false
		if child.get_node("ui/interface"):
			child.get_node("ui/interface").visible = false

func ShowScreen(screen: int = 0) -> void:
	HideAllScreens()
	if get_child_count() > screen:
		if get_child(screen) != null:
			get_child(screen).visible = true
			if get_child(screen).get_node("ui/interface"):
				get_child(screen).get_node("ui/interface").visible = true

func GetScreenBasedOnContext(context) -> int:
	var id: int = 0
	match context:
		Enums.GameContext.MAP:
			id = 2
		Enums.GameContext.SHOP:
			id = 1
			
	return id

# Connected Methods
func OnContextChanged(context) -> void:
	var screenId: int = GetScreenBasedOnContext(context)
	ShowScreen(screenId)
