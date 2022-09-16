extends Node2D

class_name Seagulls

export(float) var FlySpeed = 10

# Lifecycle Methods
func _ready() -> void:
	ResetSeagullGroup()
	
func _process(delta: float) -> void:
	position.y += FlySpeed * delta
	if position.y > get_viewport_rect().size.y + 50:
		ResetSeagullGroup()

# General Methods
func ResetSeagullGroup() -> void:
	randomize()
	var screenSize = get_viewport_rect()
	position.y = rand_range(-screenSize.size.y / 2, -screenSize.size.y / 2 - 200)
	position.x = rand_range(0, screenSize.size.x)
	FlySpeed = rand_range(4, 25)
	
	for gull in get_children():
		if gull is SeaGull:
			RandomizeGull(gull)

func RandomizeGull(gull: SeaGull) -> void:
	randomize()
	gull.FlapSpeed = rand_range(0.3, 1.0)
	gull.SwayAmount = rand_range(1.0, 10.0)
	var randomScale = rand_range(0, 2.5)
	gull.scale = Vector2(3, 3) + Vector2(randomScale, randomScale)
