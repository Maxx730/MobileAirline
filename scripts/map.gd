extends Screen

class_name Map

export(PackedScene) var WorldLocationPrefab
export(PackedScene) var AircraftMapRef
export(NodePath) var CameraRefPath

# Load the mask for the map limits
var MaskShader = preload("res://shaders/world_mask.tres")

#####################
# LIFECYCLE METHODS #
#####################
func _ready() -> void:
	SpawnMap()
	SpawnMapMask()
	SpawnLocations()
	SpawnAircraftRefs()
	
	if CameraRefPath:
		var cam: DetailCamera = get_node(CameraRefPath)
		if cam:
			cam.connect("CameraZoomChanged", self, "ResizeLocationIcons")
	
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

func SpawnMapMask() -> void:
	var maskSprite: Sprite = Sprite.new()
	var maskMaterial: ShaderMaterial = ShaderMaterial.new()
	var maskTexture: ImageTexture = ImageTexture.new()
	
	maskMaterial.set_shader_param("blur", 0.0)
	maskTexture.set_size_override(Persist.GetWorldMapImage().get_size())	
	maskMaterial.shader = MaskShader
	maskSprite.material = maskMaterial
	maskSprite.texture = maskTexture
	maskSprite.centered = false
	
	var world: Node2D = get_node("world")
	if world:
		world.add_child(maskSprite)
	
func SpawnLocations() -> void:
	if WorldLocationPrefab:
		for location in Persist.LocationData:
			var world = get_node("world")
			if world and location is Location:
				var loc: WorldLocation = location.Spawn(
					load("res://textures/icons/city-icon.png"),
					WorldLocationPrefab.instance()
				)
				loc.rect_position = loc.rect_size / -2
				location.name = "location-" + str(location.ID)
				location.add_child(loc)
				location.z_index = 100
				loc.connect("PanelButtonPressed", self, "OnWorldLocationPressed")
				world.add_child(location)
	else:
		printerr("ERROR: Unable to spawn world locations, prefab for ui missing.")

func SpawnAircraftRefs() -> void:
	for aircraft in Persist.FleetData:
		if aircraft is Aircraft:
			pass

###################
# GENERAL METHODS #
###################
func ResizeLocationIcons(scale) -> void:
	var world = get_node("world")
	if world:
		for location in world.get_children():
			if location.get_child_count() > 0:
				var panel = location.get_child(0)
				if panel is WorldLocation:
					var icon: TextureRect = panel.GetLocationIcon()
					var label: Label = panel.GetLocationLabel()
					var panelSize: Vector2 = panel.rect_size

#####################
# CONNECTED METHODS #
#####################
func OnWorldLocationPressed() -> void:
	pass
