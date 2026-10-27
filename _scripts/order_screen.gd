extends Control

func _state_changed(state):
	if state != StateManager.ProgramStates.HOME:
		self.visible = true
		get_parent().visible = true
	else:
		self.visible = false
		get_parent().visible = true
	
	update_count_label()

func update_count_label():
	var total_count = 0
	
	var texture_buttons = []
	
	for child in $BackgroundSelection/VBoxContainer.get_children():
		if child is GridContainer:
			for button in child.get_children():
				if button is TextureButton:
					texture_buttons.append(button)
					
	for texture_button in texture_buttons:
		total_count += texture_button.get_count()
	
	$PhotoCountLabel.text = "You will be taking\n" + str(total_count) + " photos" 

func _process(_delta: float) -> void:
	# this is a massive waste of CPU cycles but we are in a rush here
	if visible and get_parent().visible:
		update_count_label()
