extends Node2D

class_name Screen

export(Array, NodePath) var HiddenElements

###################
# GENERAL METHODS #
###################
func HideElements() -> void:
	for path in HiddenElements:
		if get_node(path):
			if "visible" in get_node(path):
				get_node(path).visible = false

func ShowElements() -> void:
	for path in HiddenElements:
		if get_node(path):
			if "visible" in get_node(path):
				get_node(path).visible = true
