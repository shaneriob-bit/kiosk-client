extends Node2D

var scrolling_image_array : Array[Node]
var screen_center : Vector2 

func get_leftmost_sprite() -> Node2D: 
	if scrolling_image_array.is_empty():
		return null
		
	var leftmost = scrolling_image_array[0]
	for sprite in scrolling_image_array:
		if sprite.position.x < leftmost.position.x:
			leftmost = sprite
	return leftmost

func get_rightmost_sprite() -> Node2D:
	if scrolling_image_array.is_empty():
		return null
		
	var rightmost = scrolling_image_array[0]
	for sprite in scrolling_image_array:
		if sprite.position.x > rightmost.position.x:
			rightmost = sprite
	return rightmost

func _ready() -> void:
	screen_center = get_viewport_rect().size / 2.0
	
	var preview_dir = DirAccess.open("user://previews")
	var preview_files = preview_dir.get_files()
	
	var img = Image.new()
	img.load("user://previews/" + preview_files[0])
	img.resize(1200, 800)
	var texture_img = ImageTexture.create_from_image(img)
	$ScrollingImage.texture = texture_img
	
	if preview_files.size() > 1:
		for i in range(1, preview_files.size()):
			var sprite_new = $ScrollingImage.duplicate()
			img.load("user://previews/" + preview_files[i])
			img.resize(1200, 800)
			texture_img = ImageTexture.create_from_image(img)
			sprite_new.texture = texture_img
			add_child(sprite_new)
	scrolling_image_array = get_children()
	for i in range(scrolling_image_array.size()):
		var sprite = scrolling_image_array[i]
		var position_x = (1200 * i) + screen_center.x - 2400
		sprite.position = Vector2(position_x, screen_center.y)


func _physics_process(_delta: float) -> void:
	for sprite in scrolling_image_array:
		sprite.position.x -= 1
	
	var leftmost_sprite : Node2D = get_leftmost_sprite()
	var rightmost_sprite : Node2D = get_rightmost_sprite()
	
	if leftmost_sprite.position.x <= -1800:
		# swap leftmost and rightmost sprites
		leftmost_sprite.position.x = rightmost_sprite.position.x + 1200
	
	
