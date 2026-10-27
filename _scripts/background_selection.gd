extends ScrollContainer

var background_selection_button_scene = preload("res://_scenes/background_button.tscn")

@onready var tab_bar : TabBar = $"../TabBar"

func _ready() -> void:
	var backgrounds_path = "user://backgrounds"
	var background_folder = DirAccess.open(backgrounds_path)
	
	if not background_folder:
		return
		
	background_folder.list_dir_begin()
	var next_section = background_folder.get_next()
	
	var sections = []
	while next_section != "":
		# Skip hidden folders like . and ..
		if not next_section.begins_with("."):
			sections.append(next_section)
		next_section = background_folder.get_next()
	background_folder.list_dir_end()
	
	
	var ordered_names : Array = tab_bar.get_ordered_names()
	
	if ordered_names.size() == 0:
		# fallback to the order of the tabs if no json
		for i in tab_bar.tab_count:
			ordered_names.append(tab_bar.get_tab_title(i))
	
	sections.sort_custom(func(a, b):
		var index_a = ordered_names.find(a)
		var index_b = ordered_names.find(b)
		
		# If a section isn't in the JSON array, give it a high index so it sorts to the end
		if index_a == -1:
			index_a = 99999
		if index_b == -1:
			index_b = 99999
			
		return index_a < index_b
	)
	
	# Now loop through the properly sorted sections and add them sequentially
	for section in sections:
		# Create the label
		var label = Label.new()
		label.text = section
		label.name = section
		$VBoxContainer.add_child(label)
		
		# Create the grid container
		var grid_container = GridContainer.new()
		grid_container.name = section
		grid_container.columns = 3
		$VBoxContainer.add_child(grid_container)
		
		# Get the photos and add them to the grid container
		var section_images = DirAccess.open("user://backgrounds/" + section)
		if section_images:
			section_images.list_dir_begin()
			var next_image = section_images.get_next()
			
			while next_image != "":
				if not next_image.begins_with("."):
					var img : Image = Image.new()
					img.load("user://backgrounds/" + section + "/" + next_image)
					img.resize(282, 244)
					var texture_img = ImageTexture.create_from_image(img)
					
					var texture_button : TextureButton = background_selection_button_scene.instantiate() 
					texture_button.texture_normal = texture_img
					grid_container.add_child(texture_button)
					texture_button.name = next_image
				
				next_image = section_images.get_next()
			section_images.list_dir_end()
			
	update_scroll_container_width()

func _on_tab_bar_tab_changed(tab: int) -> void:
	var tab_name = tab_bar.get_tab_title(tab)
	var label_node = $VBoxContainer.get_node(tab_name)
	self.scroll_vertical = label_node.position.y
	
func update_scroll_container_width() -> void:
	# Wait a frame for UI nodes to resolve their minimum sizes
	await get_tree().process_frame
	
	var max_content_width: float = 0.0
	
	# Find the widest control inside VBoxContainer
	for child in $VBoxContainer.get_children():
		if child is Control:
			var child_width = child.get_combined_minimum_size().x
			if child_width > max_content_width:
				max_content_width = child_width
				
	# Fetch the vertical scrollbar
	var v_scroll = get_v_scroll_bar()
	var scrollbar_width: float = 0.0
	
	# Check if vertical scrolling is enabled/needed
	if vertical_scroll_mode != ScrollContainer.SCROLL_MODE_DISABLED:
		# get_combined_minimum_size().x ensures we get the minimum width of the scrollbar theme element
		scrollbar_width = v_scroll.get_combined_minimum_size().x
		
		# Optional: Add any extra theme separation between content and scrollbar if set
		if has_theme_constant("v_scroll_bar_separation"):
			scrollbar_width += get_theme_constant("v_scroll_bar_separation")

	# Total width = widest child content + scrollbar width
	var total_width = max_content_width + scrollbar_width
	
	self.custom_minimum_size.x = total_width
	self.size.x = total_width
