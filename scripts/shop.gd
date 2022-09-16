extends Screen

class_name Shop

export(float, 0.05, 0.5) var SpawnPercentage = 0.25;
export(Array, PackedScene) var SpawnableAircraft
export(PackedScene) var ShopItemTemplate

var AvailableCraft: Array
var MaxAvailableCraft:int =  5

onready var ShopList: VBoxContainer = get_node("ui/frame/inner/scroll/content")

# Lifecycle Methods
func _ready() -> void:
	Persist.connect("PersistDataLoaded", self, "OnPersistLoaded")
	Persist.connect("PersistTick", self, "OnPersistTick")
	
	Transition.TransitionStart(true)
	
# Connected Methods
func OnPersistTick() -> void:
	print("tick")
	# Determine if we should generate a new 
	# aircraft on this tick
	if ShouldGenerateAircraft():
		GenerateAircraft()
	
	ExpirationTick()
	UpdateShopList()
			
func OnPersistLoaded() -> void:
	for aircraft in Persist.AvailableAircraft:
		var aircraftTemplate = load(aircraft.prefab)
		# Spawn the aircraft to put in Available AND spawn the list item
		var loadedAircraft = aircraftTemplate.instance() as Aircraft
		loadedAircraft.SeedData(aircraft)
		AvailableCraft.append(loadedAircraft)
	
	ClearShopList()
	BuildShopList()

# General Methods
func ShouldGenerateAircraft() -> bool:
	randomize()
	var percent = randf()
	return percent < SpawnPercentage and Persist.AvailableAircraft.size() < MaxAvailableCraft

func GenerateAircraft() -> void:
	if Persist.LocationData.size() > 0:
		randomize()
		print("Generating new available aircraft...")
		var newCraft = SpawnableAircraft[rand_range(0, SpawnableAircraft.size() - 1)].instance() as Aircraft
		newCraft.Location = Persist.LocationData[rand_range(0, Persist.LocationData.size() - 1)].id
		newCraft.ExpiresMinutes = rand_range(0, 300)
		newCraft.Name = str(rand_range(0, 1000))
		Persist.AvailableAircraft.append(newCraft.Serialize())
		AvailableCraft.append(newCraft)
		
		if ShopList and ShopItemTemplate:
			var shopItem = ShopItemTemplate.instance()
			ShopList.add_child(shopItem)

func ExpirationTick() -> void:
	for aircraft in AvailableCraft:
		if aircraft.ExpiresMinutes - 1 <= 0:
			# first delete from the persist object
			Persist.AvailableAircraft.remove(AvailableCraft.find(aircraft))
			AvailableCraft.remove(AvailableCraft.find(aircraft))
			ClearShopList()
			BuildShopList()
		else:
			aircraft.ExpiresMinutes -= 1
			var per = Persist.AvailableAircraft[AvailableCraft.find(aircraft)] as Dictionary
			per.expires = aircraft.ExpiresMinutes

# UI Methods
func ClearShopList() -> void:
	if ShopList:
		for item in ShopList.get_children():
			item.queue_free()
	else:
		printerr("Shop list does not exist, unable to clear.")

func BuildShopList() -> void:
	if ShopList and ShopItemTemplate:
		for aircraft in AvailableCraft:
			if aircraft is Aircraft:
				var shopItem = ShopItemTemplate.instance() as ShopItem
				shopItem.SetItemValues(aircraft)
				ShopList.add_child(shopItem)
	else:
		printerr("UI elements missing, unable to build shop list.")

func UpdateShopList() -> void:
	for aircraft in AvailableCraft:
		if ShopList:
			var listItem = ShopList.get_child(AvailableCraft.find(aircraft)) as ShopItem
			listItem.SetItemValues(aircraft)

func SyncronizeAvailable() -> void:
	for craft in AvailableCraft:
		if craft is Aircraft:
			for persist in Persist.AvailableAircraft:
				if craft.Identifier == persist.id:
					print("found it")
					break;
