extends Node

var TransShader: Shader = preload("res://shaders/transition.tres")
var TransitionPanel: Panel
var TransShaderMat: ShaderMaterial

var TransitionFinished: bool = false
var TransitioningIn: bool = false
var TransitionSlowdown: float = 0.3

signal OnTransitionInFinished()
signal OnTransitionOutFinished()

# Lifecycle Methods
func _ready() -> void:
	CreateTransitionNode()
	InitializeTransitionMaterial()

func _process(delta: float) -> void:
	if TransShaderMat and !TransitionFinished:
		TransShaderMat.set_shader_param("FadeAmount", move_toward(TransShaderMat.get_shader_param("FadeAmount"), 0.0 if TransitioningIn else 1.0, delta / TransitionSlowdown))
		
		if TransShaderMat.get_shader_param("FadeAmount") == 1.0:
			emit_signal("OnTransitionOutFinished")
			TransitionFinished = true
			
		if TransShaderMat.get_shader_param("FadeAmount") == 0.0:
			emit_signal("OnTransitionInFinished")
			TransitionFinished = true

# Setup Methods
func CreateTransitionNode() -> void:
	var canvas = CanvasLayer.new()
	TransitionPanel = Panel.new()
	
	TransitionPanel.mouse_filter = 2
	TransitionPanel.mouse_default_cursor_shape = 2
	TransitionPanel.anchor_bottom = 0
	TransitionPanel.anchor_top = 0
	TransitionPanel.anchor_left = 0
	TransitionPanel.anchor_right = 0
	
	TransitionPanel.rect_size = get_tree().root.get_viewport().size
	
	canvas.name = "transition_canvas"
	canvas.add_child(TransitionPanel)
	get_tree().root.call_deferred("add_child", canvas)

func InitializeTransitionMaterial() -> void:
	if TransitionPanel:
		TransShaderMat = ShaderMaterial.new()
		TransShaderMat.set_shader_param("FadeAmount", 1.0)
		TransShaderMat.shader = TransShader
		TransitionPanel.material = TransShaderMat
		
# General Methods
func TransitionStart(FadeIn: bool = false) -> void:
	TransitioningIn = FadeIn
	TransitionFinished = false
