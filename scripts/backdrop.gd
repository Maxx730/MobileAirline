extends Node2D

class_name Backdrop

onready var CanvasBackdropRef: CanvasLayer = get_node("scalable")

export(Array, NodePath) var HideExtraElements

####################
# GENERAL METHODS #
###################
func HideContents() -> void:
	if CanvasBackdropRef and CanvasBackdropRef.get_child_count() > 0:
		CanvasBackdropRef.get_child(0).visible = false
		if HideExtraElements.size() > 0:
			for element in HideExtraElements:
				get_node(element).visible = false
		
func ShowContents() -> void:
	if CanvasBackdropRef and CanvasBackdropRef.get_child(0):
		CanvasBackdropRef.get_child(0).visible = true
		if HideExtraElements.size() > 0:
			for element in HideExtraElements:
				get_node(element).visible = true
