extends Node

class_name Weather

# General Methods
func HideAllWeather() -> void:
	for child in get_children():
		if "visible" in child:
			child.visible = false
			
func ApplyWeather(type: int = 0) -> void:
	HideAllWeather()
	if type < get_child_count():
		var weatherNode = get_child(type)
		if "visible" in weatherNode:
			weatherNode.visible = true
