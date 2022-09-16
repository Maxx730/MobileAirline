extends Control

class_name Wave

export(float) var WaveSpeed = 1.0
export(float, 0.01, 0.1) var FadeSpeed = 0.05
export(float, 0.05, 0.5) var MaximumFade = 0.25
export(bool) var FadeOut = false

var FadingOut: bool = true

# Lifecycle Methods
func _process(delta: float) -> void:
	if FadeOut:
		AdjustAlpha(delta)
		
	MoveDown(delta)
	
	if rect_position.y > get_viewport_rect().size.y:
		RespawnWave()
	
func _draw() -> void:
	pass

# General Methods
func AdjustAlpha(delta) -> void:
	if rect_position.y > get_viewport_rect().size.y / 2:
		modulate.a = move_toward(modulate.a, 0, delta * 0.2)
	
func MoveDown(delta) -> void:
	rect_position.y += WaveSpeed * delta

func RespawnWave() -> void:
	rect_position = Vector2(
		-80,
		-100
	)
	modulate.a = 1.0
