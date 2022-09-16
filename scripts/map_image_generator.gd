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
	SaveNoiseValues()
	NoiseSource.seed = Persist.MapSeed
	var pixelSize = (Persist.MapSize + 1) * MAP_PIXEL_SIZE
	GenerationThread.start(self, "GenerateMapImage", {
		"noise": NoiseSource,
		"size": Vector2(pixelSize, pixelSize),
		"ui": {
			"bar": bar,
			"label": label
		}
	})

func GenerateMapImage(data: Dictionary) -> int:
	var mapImage: Image = Image.new()
	var currentPixel: int = 0
	mapImage.create(data.size.x, data.size.y, false, Image.FORMAT_RGBA8)
	mapImage.lock()
	
	for x in range(data.size.x):
		for y in range(data.size.y):
			var val: float = data.noise.get_noise_2d(x, y)
			var color: Color = Color.white
			
			if val < 0.0:
				if val < -0.45:
					color = BottomOceanColor
				elif val < -0.35:
					color = DeepOceanColor
				elif val < -0.2:
					color = MediumOceanColor
				elif val < -0.05:
					color = ShallowOceanColor
				else:
					color = ShoreOceanColor
			else:
				if val > 0.75:
					color = PeakColor
				elif val > 0.65:
					color = HighRockColor
				elif val > 0.5:
					color = RockColor
				elif val > 0.4:
					color = ForestColor
				elif val > 0.2:
					color = GrasslandColor
				elif val > 0.1:
					color = GrassEdgeColor
				elif val > 0.075:
					color = DirtColor
				elif val > 0.03:
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
			
	mapImage.unlock()
	call_deferred("SaveGenerationData")
	return mapImage.save_png("user://" + MAP_IMAGE_PATH)

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
