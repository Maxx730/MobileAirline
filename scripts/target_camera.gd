extends Camera2D

class_name TargetCamera

var CamTarget: Node2D
var Tracking: bool = true

# Lifecycle Methods
func _ready() -> void:
	Events.connect("OverworldInitialized", self, "OnWorldReady")
	Events.connect("CameraTargetChange", self, "OnTargetChange")

func _process(delta: float) -> void:
	if CamTarget and Tracking:
		position = lerp(position, CamTarget.position, delta * 10)

# Connected Methods
func OnWorldReady() -> void:
	pass

func OnTargetChange(target) -> void:
	if target is Node2D:
		CamTarget = target
