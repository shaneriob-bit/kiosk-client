extends ScrollContainer

func _ready() -> void:
	var backgrounds_path = "user://backgrounds"
	
	
	
	var background_folder = DirAccess.open(backgrounds_path)
	var next_file = background_folder.get_next()
	
	while next_file != "":
		# create the labels and grid arrays 
		var label = Label.new()
		label.text = next_file
		$VBoxContainer.add_child(label)
		
		var grid_container = GridContainer.new()
		grid_container.name = next_file
		$VBoxContainer.add_child(grid_container)
		
		
