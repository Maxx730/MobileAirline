extends Control

class_name WaveGenerator

# Preloaded Assets
var WaveTemplate = preload("res://scenes/prefabs/wave.tscn")

export(int, 0, 15) var WaveNumber = 5
export(int, 1, 10) var WaveSpeed = 1
export(bool) var FadeWavesOut = false

# Lifecycle Methods
func _ready() -> void:
	SpawnWaves(get_viewport_rect().size.y / WaveNumber)

# Startup Methods
func SpawnWaves(distanceBetween: int) -> void:
	for wave in range(WaveNumber):
		if WaveTemplate:
			var newWave = WaveTemplate.instance() as Wave
			newWave.WaveSpeed = WaveSpeed
			newWave.rect_global_position = Vector2(
				-80,
				distanceBetween * wave
			)
			newWave.FadeOut = FadeWavesOut
			add_child(newWave)

# General Methods
func RandomXOffset() -> float:
	randomize()
	return rand_range(-200, 200)
