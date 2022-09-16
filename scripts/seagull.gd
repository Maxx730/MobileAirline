extends AnimatedSprite

class_name SeaGull

export(float, 1.0, 10.0) var SwayAmount = 5.0
export(float, 0.05, 1.0) var FlapSpeed = 0.5

# Lifecycle Methods
func _ready() -> void:
	speed_scale = FlapSpeed
	
func _process(delta: float) -> void:
	position.x += sin(OS.get_unix_time()) * delta * SwayAmount

# General Methods

