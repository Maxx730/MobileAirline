extends Node

const TRANSITION_SPEED = 0.15

var TransShader: Shader = preload("res://shaders/transition.tres")
var TransitionPanel: Panel
var TransShaderMat: ShaderMaterial
var TransitionTween: Tween

var TargetMethod: FuncRef

signal OnTransitionInFinished()
signal OnTransitionOutFinished()
signal OnTransitionMiddle(obj, method)

# Lifecycle Methods
func _ready() -> void:
	CreateTransitionNode()
	InitializeTransitionMaterial()
	
	if TransitionTween:
		TransitionTween.connect("tween_all_completed", self, "OnTransitionTweenFinished")

# Setup Methods
func CreateTransitionNode() -> void:
	var canvas = CanvasLayer.new()
	TransitionPanel = Panel.new()
	TransitionTween = Tween.new()
	
	TransitionPanel.name = "transition-panel"
	TransitionPanel.mouse_filter = 2
	TransitionPanel.mouse_default_cursor_shape = 2
	TransitionPanel.anchor_bottom = 0
	TransitionPanel.anchor_top = 0
	TransitionPanel.anchor_left = 0
	TransitionPanel.anchor_right = 0
	TransitionPanel.rect_size = get_tree().root.get_viewport().size
	TransitionTween.name = "transition-tween"
	
	canvas.name = "transition_canvas"
	TransitionPanel.add_child(TransitionTween)
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
	if TransitionTween:
		TransitionTween.interpolate_property(TransitionPanel.get_material(), "shader_param/FadeAmount", 1.0 if FadeIn else 0.0, 0.0 if FadeIn else 1.0, TRANSITION_SPEED, Tween.TRANS_LINEAR, Tween.EASE_IN)
		TransitionTween.start()

func QuickTransition(method: FuncRef) -> void:
	TransitionStart(false)
	if method != null:
		TargetMethod = method

# Connected Methods
func OnTransitionTweenFinished() -> void:
	var isBlack = TransitionPanel.get_material().get_shader_param("FadeAmount")
	if isBlack:
		emit_signal("OnTransitionOutFinished")
		OnTransitionMiddle()
	else:
		emit_signal("OnTransitionInFinished")

func OnTransitionMiddle() -> void:
	if TargetMethod != null and TargetMethod is FuncRef:
		TargetMethod.call_func()
		TargetMethod = null
	TransitionStart(true)
