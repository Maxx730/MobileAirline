extends Node

enum AircraftStates {
	LANDED,
	TRANSIT
}

enum WeatherStates {
	CLEAR,
	OVERCAST,
	CLOUDY,
	RAIN,
	THUNDERSTORM,
	SNOW
}

enum WorldSizes {
	TINY,
	SMALL,
	MEDIUM,
	LARGE,
	HUGE
}

enum LocationSizes {
	SMALL,
	MEDIUM,
	LARGE,
	HUGE
}

enum LocationTypes {
	NORMAL,
	TOURISM,
	INDUSTRY
}

enum GameplayScreens {
	AIRCRAFT,
	SHOP,
	MAP
}

enum GameContext {
	IDLE,
	LOADING_CARGO,
	CHOOSE_DESTINATION,
	SHOP,
	MAP
}
