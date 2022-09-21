extends Backdrop

class_name PrototypeDetails

onready var PrototypeMap: TileMap = get_node("map")

# Lifecycle Methods
func _ready() -> void:
	var heightCells = int(get_viewport_rect().size.y / 16) + 1
	var widthCells = int(get_viewport_rect().size.x / 16) + 1
	
	for x in range(-(widthCells / 2), widthCells / 2):
		for y in range(-(heightCells / 2), heightCells / 2):
			PrototypeMap.set_cell(x, y, 0)
