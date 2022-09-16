extends Node

const DESKTOP_RES: Vector2 = Vector2(1024, 768)
const MOBILE_RES: Vector2 = Vector2(320, 480)
export(bool) var DynamicChange = false

# General Methods
func DetermineResolution() -> void:
	if (OS.get_name() == "Windows" or "OSX") and DynamicChange:
		OS.window_size = DESKTOP_RES
		get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_VIEWPORT, SceneTree.STRETCH_ASPECT_EXPAND, DESKTOP_RES)
