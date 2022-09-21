extends Control

onready var DrawButton: Button = get_node("test/draw")
onready var TestImage: TextureRect = get_node("test/img")

func _ready() -> void:
	Transition.TransitionStart(true)
	if DrawButton and TestImage:
		DrawButton.connect("pressed", self, "DrawButtonPressed")
		
func DrawButtonPressed() -> void:
	randomize()
	var img: Image = Image.new()
	var size = get_child(0).rect_size
	img.create(size.x, size.y, false, Image.FORMAT_RGBA8)
	if TestImage:
		var imgTexture = ImageTexture.new()
		for i in 25:
			Utils.DrawTree(img, rand_range(0, 100), rand_range(0, 100), rand_range(5, 15))
		imgTexture.create_from_image(img)
		TestImage.texture = imgTexture
