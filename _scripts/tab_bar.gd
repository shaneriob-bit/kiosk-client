extends TabBar

var ordered_names: Array = []

func _init() -> void:
	var bg_dir = "user://backgrounds"
	var config_file = "user://config/section-order.json"
	
	# 1. Safely handle directory access
	var section_names = []
	if DirAccess.dir_exists_absolute(bg_dir):
		section_names = DirAccess.get_directories_at(bg_dir)
	else:
		push_warning("Directory not found: ", bg_dir)
	
	# 2. Safely handle file access
	if FileAccess.file_exists(config_file):
		var order_file = FileAccess.open(config_file, FileAccess.READ)
		
		# Ensure the file actually opened successfully
		if order_file:
			var json_string = order_file.get_as_text()
			order_file.close()
			
			var json = JSON.new()
			var error = json.parse(json_string)

			if error == OK:
				# Ensure the parsed data is a Dictionary and contains our key
				if typeof(json.data) == TYPE_DICTIONARY and json.data.has("section-order"):
					var parsed_array = json.data["section-order"]
					if typeof(parsed_array) == TYPE_ARRAY:
						ordered_names = parsed_array
					else:
						push_error("JSON 'section-order' is not an Array.")
				else:
					push_error("JSON data is not a Dictionary or missing 'section-order' key.")
			else:
				push_error("JSON Parse Error: ", json.get_error_message(), " at line ", json.get_error_line())
		else:
			push_error("Failed to open file: ", config_file)
	else:
		push_warning("Config file not found: ", config_file)
	
	# 3. Add tabs based on the JSON array order
	for section_name in ordered_names:
		# Only add the tab if a corresponding directory was actually found
		if section_name in section_names:
			add_tab(section_name)
			
	# Add any background directories that exist but weren't listed in the JSON config
	for section_name in section_names:
		if not section_name in ordered_names:
			add_tab(section_name)
	
	# "make all the tabs the same size"
	var longest_string_length = 0
	for i in tab_count:
		var tab_text = get_tab_title(i)
		set_tab_metadata(i, tab_text)
		if tab_text.length() > longest_string_length:
			longest_string_length = tab_text.length()
	
	for i in tab_count:
		var tab_text = get_tab_title(i)
		var length_diff = longest_string_length - tab_text.length()
		if length_diff > 0:
			set_tab_title(i, tab_text + " ".repeat(length_diff))

func get_ordered_names() -> Array:
	return ordered_names
