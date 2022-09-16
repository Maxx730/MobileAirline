tool
extends CanvasModulate

class_name Daylight

export(int, 0, 23) var CurrentHour = 12 setget SetCurrentHour
export(Color) var MorningColor setget SetMorningColor
export(Color) var DayColor setget SetDayColor
export(Color) var EveningColor setget SetEveningColor
export(Color) var NightColor setget SetNightColor
	
# Connected Methods

# General Methods
func SetDaylightColor(hour: int) -> void:
	if hour > 20 or hour < 5:
		color = NightColor
	elif hour > 5 and hour < 8:
		color = MorningColor
	elif hour > 18 and hour < 21:
		color = EveningColor
	else:
		color = DayColor

# Setters
func SetCurrentHour(hour: int) -> void:
	CurrentHour = hour
	SetDaylightColor(hour)
	
func SetMorningColor(color: Color) -> void:
	MorningColor = color

func SetDayColor(color: Color) -> void:
	DayColor = color
	
func SetEveningColor(color: Color) -> void:
	EveningColor = color
	
func SetNightColor(color: Color) -> void:
	NightColor = color
