extends TileMap

class_name Clouds

var CloudNoise: OpenSimplexNoise

# Lifecycle Methods
func _ready() -> void:
	CloudNoise = OpenSimplexNoise.new()
	CloudNoise.period = 35.0
	CloudNoise.octaves = 4
	CloudNoise.persistence = 0.4
	CloudNoise.lacunarity = 2

# Generation Methods
func GenerateClouds(width: int, height: int) -> Array:
	randomize()
	CloudNoise.seed = randi()
	var data = Array()
	
	for x in range(-(width / 2), (width / 2)):
		for y in range(-(height / 2), (height / 2)):
			data.append({
				"x": x,
				"y": y,
				"cell": GetValue(x, y)
			})
	
	return data

func GetValue(x: int, y: int) -> int:
	var value = CloudNoise.get_noise_2d(x, y)
	var tile = -1
	
	if value > 0.05:
		tile = 0
	
	return tile

# General Methods
func ApplyData(data: Array) -> void:
	for cell in data:
		set_cell(cell.x, cell.y, cell.cell)
