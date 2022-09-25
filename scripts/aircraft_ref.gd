extends Node2D

class_name AircraftRef

var AircraftSource: int = 1
var TravelLine: Line2D

# LIFECYCLE METHODS
func _draw() -> void:
	if State.GameplayContext == Enums.GameContext.CHOOSE_DESTINATION and AircraftSource == State.FocusedAircraft:
		var aircraft = Persist.FleetData[AircraftSource]
		if aircraft is Aircraft:
			var radius: float = aircraft.MilesPerGallon * aircraft.MaxFuel
			draw_circle(Vector2.ZERO, radius, Color(1, 1, 1, 0.15))

func _ready() -> void:
	Persist.connect("PersistTick", self, "OnWorldTick")

# CONNECTED METHDOS
func OnWorldTick() -> void:
	var source = Persist.FleetData[AircraftSource] as Aircraft
	if source.Destination > 0:			
		var loc: Location = Persist.GetLocationFromLocationId(source.Destination)
		# turn towards the target destination
		TurnToDestination(loc)
		MoveTowardsDestination(loc)
		
		# DRAW LINE
		if TravelLine == null:
			SpawnTravelLine(loc)
		else:
			UpdateTravelLine(loc)
		UpdateSource(source)
		
		# LANDED LOGIC
		if position.distance_to(loc.position) < 5.0:
			source.Destination = -1
			source.State = Enums.AircraftStates.LANDED
			source.LocationID = loc.ID
			if TravelLine:
				TravelLine.queue_free()
				remove_child(TravelLine)
				TravelLine = null
				Events.emit_signal("AircraftLanded", AircraftSource)
				Persist.CompletedFlights += 1
	else:
		get_node("icon").rotation_degrees = 0

func TurnToDestination(dest: Location) -> void:
	var dir = dest.position - position
	var deg = rad2deg(dir.angle())
	get_node("icon").rotation_degrees = deg

func MoveTowardsDestination(dest: Location) -> void:
	# DETERMINE HOW FAR TO MOVE BASED ON SPEED
	var aircraft = Persist.FleetData[AircraftSource]
	if aircraft is Aircraft:
		# MULTIPLY THE REAL LIFE VALUE BY 10 TO NOT HAVE SUPER LONG
		# TRAVEL TIMES
		var travelPerSecond = ((aircraft.Speed / 60.0) / 60.0) * 10
		var fuelUsed = travelPerSecond / aircraft.MilesPerGallon
		position += get_node("icon").transform.x * travelPerSecond
		aircraft.CurrentFuel -= fuelUsed

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
