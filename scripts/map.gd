extends Screen

class_name Map

#####################
# LIFECYCLE METHODS #
#####################
func _ready() -> void:
	SpawnMap()
	SpawnLocations()
	
###################
# STARTUP METHODS #
###################
func SpawnMap() -> void:
	var mapSprite: Sprite = Sprite.new()
	mapSprite.texture = Persist.GetWorldMapTexture()
	mapSprite.name = "overworld_sprite"
	mapSprite.centered = false
	var world: Node2D = get_node("world")
	if world:
		world.add_child(mapSprite)
	
func SpawnLocations() -> void:
	for location in Persist.LocationData:
		var world = get_node("world")
		if world and location is Location:
			var sprite: Sprite = location.Spawn(
				load("res://textures/icons/city-icon.png")
			)
			sprite.z_index = 5
			sprite.position = Vector2(0, 0)
			location.name = "location-" + str(location.ID)
			location.add_child(sprite)
			world.add_child(location)
