extends PanelButton

class_name WorldLocation

export(float) var AnimationSpeed: float = 0.5

#####################
# LIFECYCLE METHODS #
#####################
func _process(delta) -> void:
	pass

# GENERAL METHODS
func GetLocationIcon() -> TextureRect:
	return get_node("icon") as TextureRect

func GetLocationLabel() -> Label:
	return get_node("name") as Label
