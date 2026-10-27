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
	
	const PREVIEW_DIR_PATH := "user://previews"
	
	# 1. Check if directory exists before attempting to open
	if not DirAccess.dir_exists_absolute(PREVIEW_DIR_PATH):
		push_warning("Directory does not exist: %s" % PREVIEW_DIR_PATH)
		return

	var preview_dir := DirAccess.open(PREVIEW_DIR_PATH)
	if preview_dir == null:
		push_error("Failed to open directory: %s (Error: %s)" % [PREVIEW_DIR_PATH, DirAccess.get_open_error()])
		return

	# 2. Get files and handle empty directory cases
	var preview_files := preview_dir.get_files()
	if preview_files.is_empty():
		push_warning("No files found in directory: %s" % PREVIEW_DIR_PATH)
		return

	# 3. Filter out non-image files if necessary (e.g. .import files or hidden OS files)
	var valid_files: Array[String] = []
	for file_name in preview_files:
		if not file_name.ends_with(".import") and (file_name.ends_with(".png") or file_name.ends_with(".jpg") or file_name.ends_with(".webp")):
			valid_files.append(file_name)

	if valid_files.is_empty():
		push_warning("No supported image files found in: %s" % PREVIEW_DIR_PATH)
		return

	# 4. Safely load images into sprites
	var loaded_sprites: Array[Node] = []
	
	for i in range(valid_files.size()):
		var file_path := PREVIEW_DIR_PATH.path_join(valid_files[i])
		var img := Image.new()
		var error := img.load(file_path)
		
		# Guard against corrupted or invalid image files
		if error != OK:
			push_error("Failed to load image at path '%s'. Error code: %s" % [file_path, error])
			continue

		img.resize(1200, 800)
		var texture_img := ImageTexture.create_from_image(img)
		
		var sprite: Sprite2D
		if loaded_sprites.is_empty():
			# Configure initial baseline sprite
			sprite = $ScrollingImage
			sprite.texture = texture_img
		else:
			# Duplicate baseline sprite for additional images
			sprite = $ScrollingImage.duplicate()
			sprite.texture = texture_img
			add_child(sprite)

		loaded_sprites.append(sprite)

	scrolling_image_array = loaded_sprites
	
	# 5. Position loaded sprites
	for i in range(scrolling_image_array.size()):
		var sprite := scrolling_image_array[i] as Node2D
		if sprite:
			var position_x := (1200 * i) + screen_center.x - 2400
			sprite.position = Vector2(position_x, screen_center.y)


func _physics_process(_delta: float) -> void:
	if scrolling_image_array.is_empty():
		return

	for sprite in scrolling_image_array:
		if sprite is Node2D:
			sprite.position.x -= 1
	
	var leftmost_sprite := get_leftmost_sprite()
	var rightmost_sprite := get_rightmost_sprite()
	
	# Guard against null references before modifying positions
	if leftmost_sprite and rightmost_sprite:
		if leftmost_sprite.position.x <= -1800:
			leftmost_sprite.position.x = rightmost_sprite.position.x + 1200
