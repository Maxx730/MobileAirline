extends Node

#####################
# LIFECYCLE METHODS #
#####################
func _ready() -> void:
	Persist.connect("PersistTick", self, "OnPersistTick")

#####################
# CONNECTED METHODS #
#####################
func OnPersistTick() -> void:
	if ShouldGenerateAircraft():
		print("generating aircraft")
	
################
# UTIL METHODS #
################
func ShouldGenerateAircraft() -> bool:
	randomize()
	var percent = randf()
	return percent < 0.05 and Persist.AvailableAircraft.size() < 5
