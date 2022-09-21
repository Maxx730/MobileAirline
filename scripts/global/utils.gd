extends Node

func DrawTree(img: Image, x: int, y: int, radius: int = 5, c: Color = Color.white) -> void:
	var pi = 3.1415926535
	var angle
	var x1
	var y1
	var color = Color.red

	for r in range(radius, 0, -1):
		var sectionHeight = radius / 3.0
		if r < sectionHeight:
			# top
			color = Color.red
		elif r < sectionHeight * 2:
			# middle
			color = Color.blue
		else:
			# bottom
			color = Color.white
			
		for i in range(0, 360):
			angle = i
			x1 = r * cos(angle * pi / 180)
			y1 = r * sin(angle * pi / 180)
			var xpoint = x + x1
			var ypoint = y + y1
			if xpoint > 0 and xpoint < img.get_size().x and ypoint > 0 and ypoint < img.get_size().y:
				img.set_pixel(x + x1, y + y1, color)

