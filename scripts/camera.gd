extends Camera2D

class_name DetailCamera

export(NodePath) var ZoomInPath
export(NodePath) var ZoomOutPath
export(NodePath) var RecenterPath

export(float, 5.0, 25,0) var DragSpeed = 15.0

onready var GamePlayRef: Gameplay = get_tree().root.get_node("gameplay")

var MouseIsDown: bool = false
var TargetZoom: float = 1.0
var ZoomSpeed: float = 2.0
var TargetPosition: Vector2 = Vector2.ZERO

signal CameraZoomChanged(zoom)

#####################
# LIFECYCLE METHODS #
#####################
func _ready() -> void:
	Events.connect("ContextChanged", self, "OnContextChange")
	
	if ZoomInPath and get_node(ZoomInPath):
		get_node(ZoomInPath).connect("pressed", self, "OnZoomInPressed")
		
	if ZoomOutPath and get_node(ZoomOutPath):
		get_node(ZoomOutPath).connect("pressed", self, "OnZoomOutPressed")
		
	if RecenterPath and get_node(RecenterPath):
		get_node(RecenterPath).connect("PanelButtonPressed", self, "OnRecenterPressed")

	TargetPosition = Persist.GetWorldMapImage().get_size() / 2

func _input(event) -> void:
	if GamePlayRef and GamePlayRef.GameplayContext == Enums.GameContext.MAP or GamePlayRef.GameplayContext == Enums.GameContext.CHOOSE_DESTINATION:
		if event is InputEventMouseButton:
			if event.pressed and event.button_index == BUTTON_LEFT:
				MouseIsDown = true
			else:
				MouseIsDown = false
		
		if event is InputEventMouseMotion:
			if MouseIsDown:
				TargetPosition -= event.relative / 2
		
		update()

func _process(delta) -> void:
	if GamePlayRef and GamePlayRef.GameplayContext == Enums.GameContext.MAP or GamePlayRef.GameplayContext == Enums.GameContext.CHOOSE_DESTINATION:
		var nextZoom = move_toward(zoom.x, TargetZoom, delta * ZoomSpeed)
		zoom = Vector2(nextZoom, nextZoom)
		position = position.move_toward(TargetPosition, 25)

#####################
# CONNECTED METHODS #
#####################
func OnContextChange(context) -> void:
	if context == Enums.GameContext.IDLE:
		position = Vector2.ZERO
		zoom = Vector2(1, 1)
		
	if context == Enums.GameContext.MAP or context == Enums.GameContext.CHOOSE_DESTINATION:
		var resetPos: Vector2 = Persist.GetWorldMapImage().get_size() / 2
		position = resetPos
		zoom = Vector2(1, 1)
		TargetPosition = resetPos
		TargetZoom = 1

func OnZoomInPressed() -> void:
	TargetZoom = clamp(TargetZoom - 0.5, 0.5, 2.0)
	emit_signal("CameraZoomChanged", TargetZoom)
	
func OnZoomOutPressed() -> void:
	TargetZoom = clamp(TargetZoom + 0.5, 0.5, 2.0)
	emit_signal("CameraZoomChanged", TargetZoom)

func OnRecenterPressed() -> void:
	var cent = Persist.GetWorldMapImage().get_size() / 2
	TargetPosition = cent
