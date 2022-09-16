extends Node

class_name ShopItem

# General Methods
func SetItemValues(aircraft: Aircraft) -> void:
	var ItemName: Label = get_node("top/name")
	var ItemPrice: Label = get_node("top/price")
	var CargoValue: Label = get_node("stats/cargo/content/value")
	var SpeedValue: Label = get_node("stats/speed/content/value")
	var FuelValue: Label = get_node("stats/fuel/content/value")
	var SeatValue: Label = get_node("stats/seats/content/value")
	var ExpireValue: Label = get_node("expiration")
	
	if ItemName:
		ItemName.text = aircraft.Name
	
	if CargoValue:
		CargoValue.text = str(aircraft.Cargo.size())
		
	if SpeedValue:
		SpeedValue.text = str(aircraft.Speed)
		
	if FuelValue:
		FuelValue.text = str(aircraft.MaxFuel)
		
	if SeatValue:
		SeatValue.text = str(aircraft.Seats.size())
		
	if ExpireValue:
		var minutes = ceil(aircraft.ExpiresMinutes / 60)
		ExpireValue.text = "Expires in " + str(minutes) + " minute(s)" 
