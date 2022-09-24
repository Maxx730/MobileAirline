extends Node2D

class_name AircraftRef

var AircraftSource: int = 1
var TravelLine: Line2D

# LIFECYCLE METHODS
func _draw() -> void:
	if State.GameplayContext == Enums.GameContext.CHOOSE_DESTINATION:
		pass

func _ready() -> void:
	Persist.connect("PersistTick", self, "OnWorldTick")

# CONNECTED METHDOS
func OnWorldTick() -> void:
	var source = Persist.FleetData[AircraftSource]
	if source.Destination > 0:			
		var loc: Location = Persist.GetLocationFromLocationId(source.Destination)
		# turn towards the target destination
		TurnToDestination(loc)
		MoveTowardsDestination(loc)
		if TravelLine == null:
			SpawnTravelLine(loc)
		else:
			UpdateTravelLine(loc)
		UpdateSource(source)
		
		if position.distance_to(loc.position) < 5.0:
			source.Destination = -1
			source.State = Enums.AircraftStates.LANDED
			if TravelLine:
				TravelLine.queue_free()
				remove_child(TravelLine)
				TravelLine = null
				Events.emit_signal("AircraftLanded", AircraftSource)
				Persist.CompletedFlights += 1
	else:
		rotation_degrees = 0

func TurnToDestination(dest: Location) -> void:
	var dir = dest.position - position
	var deg = rad2deg(dir.angle())
	rotation_degrees = deg

func MoveTowardsDestination(dest: Location) -> void:
	position += transform.x * 5

func SpawnTravelLine(dest) -> void:
	TravelLine = Line2D.new()
	TravelLine.width = 2
	TravelLine.default_color = Color(1, 1, 1, 0.25)
	TravelLine.points = [
		Vector2.ZERO,
		to_local(dest.position)
	]
	add_child(TravelLine)

func UpdateTravelLine(dest) -> void:
	TravelLine.points = [
		Vector2.ZERO,
		to_local(dest.position)
	]

func UpdateSource(source) -> void:
	if source:
		source.MapPosition = self.position
