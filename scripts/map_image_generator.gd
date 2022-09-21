extends Node

const MAP_IMAGE_PATH = "generate-map.png"
const MAP_PIXEL_SIZE = 500

class_name MapImageGenerator
var GenerationThread: Thread

# NOISE OBJECT
export(OpenSimplexNoise) var NoiseSource: OpenSimplexNoise

# MAP COLORS
# WATER COLORS
export(Color) var BottomOceanColor
export(Color) var DeepOceanColor
export(Color) var MediumOceanColor
export(Color) var ShallowOceanColor
export(Color) var ShoreOceanColor
# LAND COLORS
export(Color) var WetSandColor
export(Color) var BeachColor
export(Color) var DirtColor
export(Color) var GrassEdgeColor
export(Color) var GrasslandColor
export(Color) var ForestColor
export(Color) var TreeColor
# MOUNTAIN COLORS
export(Color) var RockColor
export(Color) var HighRockColor
export(Color) var PeakColor

signal MapGenerationComplete()
signal MapGenerationUpdate(level)

# GENERAL METHODS
func GenerateWorldMap(bar: ProgressBar = null, label: Label = null) -> void:
	GenerationThread = Thread.new()
	randomize()
	NoiseSource.seed = Persist.MapSeed
	NoiseSource.lacunarity = Persist.MapLacunarity
	NoiseSource.persistence = Persist.MapPersistence
	NoiseSource.octaves = Persist.MapOctaves
	NoiseSource.period = Persist.MapPeriod
	SaveNoiseValues()

	var ForestNoise: OpenSimplexNoise = OpenSimplexNoise.new()
	ForestNoise.seed = randi()
	ForestNoise.period = NoiseSource.period
	ForestNoise.lacunarity = NoiseSource.lacunarity
	ForestNoise.persistence = NoiseSource.persistence
	ForestNoise.octaves = NoiseSource.octaves
	
	var pixelSize = (Persist.MapSize + 1) * MAP_PIXEL_SIZE
	GenerationThread.start(self, "GenerateMapImage", {
		"noise": NoiseSource,
		"forest": ForestNoise,
		"size": Vector2(pixelSize, pixelSize),
		"ui": {
			"bar": bar,
			"label": label
		}
	})

func GenerateMapImage(data: Dictionary) -> int:
	var mapImage: Image = Image.new()
	var currentPixel: int = 0
	var waterLevel: float = Persist.MapWaterLevel - 0.5
	var forestNoise: OpenSimplexNoise = data.forest
	var treeSpawns: Array = Array()
	mapImage.create(data.size.x, data.size.y, false, Image.FORMAT_RGBA8)
	mapImage.lock()
	
	for x in range(data.size.x):
		for y in range(data.size.y):
			var val: float = data.noise.get_noise_2d(x, y)
			var color: Color = Color.white
			var shouldSpawnTree: bool = false
			
			if val < waterLevel:
				if val < waterLevel - 0.45:
					color = BottomOceanColor
				elif val < waterLevel - 0.35:
					color = DeepOceanColor
				elif val < waterLevel - 0.2:
					color = MediumOceanColor
				elif val < waterLevel - 0.02:
					color = ShallowOceanColor
				else:
					color = ShoreOceanColor
			else:
				if val >  0.55:
					color = PeakColor
				elif val > 0.5:
					color = HighRockColor
				elif val > 0.45:
					color = RockColor
				elif val > waterLevel + 0.25:
					if forestNoise.get_noise_2d(x, y) > 0.25:
						treeSpawns.append(
							Vector2(x, y)
						)
					color = ForestColor
				elif val > waterLevel + 0.2:
					color = GrasslandColor
				elif val > waterLevel + 0.1:
					color = GrassEdgeColor
				elif val > waterLevel + 0.075:
					color = DirtColor
				elif val > waterLevel + 0.02:
					color = BeachColor
				else:
					color = WetSandColor
			
			currentPixel += 1
			var amountDone = currentPixel / (data.size.x * data.size.y)
			if data.has("ui") and data.ui:
				if data.ui.has("bar") and data.ui.bar:
					data.ui.bar.value = amountDone * 50
				
				if data.ui.has("label") and data.ui.label:
					data.ui.label.text = str(floor(amountDone * 50)) + "%"

			mapImage.set_pixel(x, y, color)
	
	# Loop through the tree points and spawn them
	for tree in treeSpawns:
		mapImage.set_pixel(tree.x, tree.y, TreeColor)
		
	mapImage.unlock()
	call_deferred("SaveGenerationData")
	return mapImage.save_png("user://" + MAP_IMAGE_PATH)

func GenerateCloudImage(data: Dictionary) -> int:
	return 0

func SaveGenerationData() -> void:
	var imageData = GenerationThread.wait_to_finish()
	if imageData == OK:
		emit_signal("MapGenerationComplete")
	else:
		printerr("ERROR: There was an error generating world map image.")

func SaveNoiseValues() -> void:
	Persist.MapOctaves = NoiseSource.octaves
	Persist.MapLacunarity = NoiseSource.lacunarity
	Persist.MapPeriod = NoiseSource.period
	Persist.MapPersistence = NoiseSource.persistence
	Persist.Save()
