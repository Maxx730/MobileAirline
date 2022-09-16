extends Node

var DialogTemplate: PackedScene = preload("res://scenes/prefabs/ui/simple_dialog.tscn")

# Lifecycle Methods

# General Methods
func CreateDialog(title: String = "", subtitle: String = "", message: String = "", parent: Node = null) -> SimpleDialog:
	var newDialog = DialogTemplate.instance() as SimpleDialog
	newDialog.call_deferred("SetDialogInformation", title, subtitle, message)
	if parent:
		print("Adding new dialog to parent...")
		parent.add_child(newDialog)
		newDialog.popup()
	return newDialog
