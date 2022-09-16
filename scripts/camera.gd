extends Camera2D

class_name DetailCamera

export(float, 10.0, 25,0) var DragSpeed = 15.0

onready var GamePlayRef: Gameplay = get_tree().root.get_node("gameplay")

var MouseIsDown: bool = false

#####################
# LIFECYCLE METHODS #
#####################
func _ready() -> void:
	Events.connect("ContextChanged", self, "OnContextChange")

func _input(event) -> void:
	if GamePlayRef and GamePlayRef.GameplayContext == Enums.GameContext.MAP:
		if event is InputEventMouseButton:
			if event.pressed and event.button_index == BUTTON_LEFT:
				MouseIsDown = true
			else:
				MouseIsDown = false
		
		if event is InputEventMouseMotion:
			if MouseIsDown:
				position -= event.relative.normalized() * DragSpeed

#####################
# CONNECTED METHODS #
#####################
func OnContextChange(context) -> void:
	if context == Enums.GameContext.IDLE:
		position = Vector2.ZERO
