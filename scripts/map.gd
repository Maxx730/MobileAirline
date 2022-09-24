extends Screen

class_name Map

export(PackedScene) var WorldLocationPrefab
export(PackedScene) var AircraftMapRef
export(NodePath) var CameraRefPath

onready var AircraftList: Node2D = get_node("aircraft_refs")

# Load the mask for the map limits
var MaskShader = preload("res://shaders/world_mask.tres")

##################
# LIFECYCLE METHODS #
#####################
func _ready() -> void:
	#SpawnMap()
	#SpawnMapMask()
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
				var loc: WorldLocation = WorldLocationPrefab.instance()
				loc.LocationRef = location
				loc.SetUIElements(location.Name)
				location.name = "location-" + str(location.ID)
				location.add_child(loc)
				loc.connect("OnLocationPressed", self, "OnWorldLocationPressed")
				world.add_child(location)
	else:
		printerr("ERROR: Unable to spawn world locations, prefab for ui missing.")

func SpawnAircraftRefs() -> void:
	if AircraftList and AircraftMapRef:
		for aircraft in Persist.FleetData:
			if aircraft is Aircraft:
				var Mapref: AircraftRef = AircraftMapRef.instance()
				Mapref.AircraftSource = Persist.FleetData.find(aircraft)
				Mapref.position = aircraft.MapPosition
				AircraftList.add_child(Mapref)

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
					pass

#####################
# CONNECTED METHODS #
#####################
func OnWorldLocationPressed(id) -> void:
	if State.GameplayContext == Enums.GameContext.CHOOSE_DESTINATION:		
		var dialog: SimpleDialog = GlobalDialog.CreateDialog("Ready to Depart?", "Confirm aircraft travel to ", "Aircraft () ready for departure to ", get_node("ui"), [id])
		
		dialog.connect("OnDialogConfirm", self, "OnDepartConfirmed")
	else:
		# ask they player if they would like to unlock
		pass

func OnDepartConfirmed(args) -> void:
	var craft: Aircraft = Persist.FleetData[State.FocusedAircraft]
	craft.State = Enums.AircraftStates.TRANSIT
	craft.Destination = args[0]
	Events.emit_signal("ContextChanged", Enums.GameContext.IDLE)
	Events.emit_signal("AircraftChanged", State.FocusedAircraft)
	Persist.Save()
