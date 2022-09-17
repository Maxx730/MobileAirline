extends Node2D

class_name WorldGen

const CAM_MOVEMENT: bool = false

onready var WorldCamera: Camera2D = get_node("camera")
onready var ZoomInButton: Button = get_node("frame/interface/zoom/actions/in")
onready var ZoomOutButton: Button = get_node("frame/interface/zoom/actions/out")
onready var WorldMapSprite: Sprite = get_node("frame/map")
onready var RandomizeValuesButton: Button = get_node("frame/interface/debug/randomize")
onready var ExitButton: Button = get_node("frame/interface/debug/exit/exit")
onready var UseNoiseVariables: PanelButton = get_node("frame/interface/use")

# Noise Elements
var NoiseSource: OpenSimplexNoise
var WorldShader: ShaderMaterial
onready var PeriodSlider: Slider = get_node("frame/interface/sliders/options/scale/value")
onready var DetailSlider: Slider = get_node("frame/interface/sliders/options/detail/value")
onready var WaterSlider: Slider = get_node("frame/interface/sliders/options/water/value")
onready var GranualaritySlider: Slider = get_node("frame/interface/sliders/options/granularity/value")

# Debug Elements
onready var DebugSeedLabel: Label = get_node("frame/interface/debug/list/seed")
onready var DebugZoomLabel: Label = get_node("frame/interface/debug/list/zoom")

var WorldGenNoise: OpenSimplexNoise
var IsMouseDown: bool = false
var IsChanging: bool = false
var TargetCameraZoom: float = 1
var NextScene

# Lifecycle Methods
func _ready() -> void:
	WorldGenNoise = WorldMapSprite.texture.noise as OpenSimplexNoise
	Transition.TransitionStart(true)
	Transition.connect("OnTransitionOutFinished", self, "OnTransitionOutEnd")
	SetDebugInformation()
	
	var noiseText: NoiseTexture = get_node("frame/map").texture
	NoiseSource = noiseText.noise
	WorldShader = get_node("frame/map").material
	
	# Connect Debug Elements
	if RandomizeValuesButton:
		RandomizeValuesButton.connect("pressed", self, "OnRandomizeButtonPressed")
		
	if ExitButton:
		ExitButton.connect("pressed", self, "OnExitButtonPressed")
	
	if ZoomInButton:
		ZoomInButton.connect("pressed", self, "OnZoomInPressed")
		
	if ZoomOutButton:
		ZoomOutButton.connect("pressed", self, "OnZoomOutPressed")
	
	if UseNoiseVariables:
		UseNoiseVariables.connect("PanelButtonPressed", self, "OnUseValuesPressed")
	
	if PeriodSlider and DetailSlider and WaterSlider:
		PeriodSlider.connect("drag_started", self, "OnSliderStarted")
		PeriodSlider.connect("drag_ended", self, "OnSliderEnded")
		DetailSlider.connect("drag_started", self, "OnSliderStarted")
		DetailSlider.connect("drag_ended", self, "OnSliderEnded")
		WaterSlider.connect("drag_started", self, "OnSliderStarted")
		WaterSlider.connect("drag_ended", self, "OnSliderEnded")
		GranualaritySlider.connect("drag_started", self, "OnSliderStarted")
		GranualaritySlider.connect("drag_ended", self, "OnSliderEnded")
	
	Persist.connect("PersistDataLoaded", self, "OnPersistLoaded")
	Persist.Load()
	
func _input(event: InputEvent) -> void:
	if CAM_MOVEMENT:
		if event is InputEventMouseButton:
			if event.button_index == BUTTON_LEFT:
				IsMouseDown = event.pressed
				
		if IsMouseDown and event is InputEventMouseMotion:
			if WorldCamera:
				WorldCamera.position -= event.relative / 2

func _process(delta) -> void:
	if WorldCamera:
		var nextZoom = move_toward(WorldCamera.zoom.x, TargetCameraZoom, delta)
		WorldCamera.zoom = Vector2(nextZoom, nextZoom)
	
	if NoiseSource and IsChanging:
		NoiseSource.persistence = DetailSlider.value
		NoiseSource.period = PeriodSlider.value
		NoiseSource.octaves = GranualaritySlider.value
		if WorldShader:
			WorldShader.set_shader_param("WaterLevel", WaterSlider.value)
		
# General Methods
func SetDebugInformation() -> void:
	if WorldGenNoise:
		if DebugSeedLabel:
			DebugSeedLabel.text = "SEED: " + str(WorldGenNoise.seed)
	
	if WorldCamera:
		if DebugZoomLabel:
			DebugZoomLabel.text = "ZOOM: " + str(WorldCamera.zoom)

# Connected Methods
func OnRandomizeButtonPressed() -> void:
	randomize()
	var randomSeed = randi()
	WorldGenNoise.seed = randomSeed
	SetDebugInformation()

func OnExitButtonPressed() -> void:
	NextScene = "res://scenes/screens/menu.tscn"
	Transition.TransitionStart(false);

func OnTransitionOutEnd() -> void:
	if NextScene != null:
		get_tree().change_scene(NextScene)

func OnZoomInPressed() -> void:
	TargetCameraZoom = clamp(TargetCameraZoom - 0.1, 0.1, 2)
	
func OnZoomOutPressed() -> void:
	TargetCameraZoom = clamp(TargetCameraZoom + 0.1, 0.1, 2)

func OnSliderStarted() -> void:
	IsChanging = true

func OnSliderEnded(value) -> void:
	IsChanging = false

func OnUseValuesPressed() -> void:
	Persist.MapPersistence = NoiseSource.persistence
	Persist.MapSeed = NoiseSource.seed
	Persist.MapOctaves = NoiseSource.octaves
	Persist.MapPeriod = NoiseSource.period
	Persist.MapLacunarity = NoiseSource.lacunarity
	NextScene = "res://scenes/screens/begin.tscn"
	Transition.TransitionStart(false)
	
func OnPersistLoaded() -> void:
	var noiseText: NoiseTexture = get_node("frame/map").texture
	if noiseText:
		noiseText.width = 100 * (Persist.MapSize + 1)
		noiseText.height = 100 * (Persist.MapSize + 1)
		
	
# Persistence Methods
func SaveAsMapFile() -> void:
	pass
