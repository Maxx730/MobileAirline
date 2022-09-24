extends Node

var DialogTemplate: PackedScene = preload("res://scenes/prefabs/ui/simple_dialog.tscn")

# Lifecycle Methods

# General Methods
func CreateDialog(title: String = "", subtitle: String = "", message: String = "", parent: Node = null, args: Array = []) -> SimpleDialog:
	var newDialog = DialogTemplate.instance() as SimpleDialog
	newDialog.call_deferred("SetDialogInformation", title, subtitle, message)
	newDialog.call_deferred("AddData", args)
	if parent:
		parent.add_child(newDialog)
		newDialog.popup()
	return newDialog
