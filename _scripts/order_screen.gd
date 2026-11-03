extends Control

func _state_changed(state):
	if state == StateManager.ProgramStates.BACKGROND:
		self.visible = true
		get_parent().visible = true
	else:
		self.visible = false
		get_parent().visible = true
		
	var texture_buttons = []
	
	for child in $BackgroundSelection/VBoxContainer.get_children():
		if child is GridContainer:
			for button in child.get_children():
				if button is TextureButton:
					if button.button_pressed == true:
						texture_buttons.append(button)
	
	# add them to the state manager array
	for texture_button in texture_buttons:
		StateManager.selected_backgrounds.append(texture_button)
	
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
	
	$NextButton.visible = total_count > 0
	$DisabledButtonInfo.visible = total_count <= 0
	
	$PhotoCost.text = "$%.2f" % (StateManager.base_price * total_count)
	
	StateManager.total_photos = total_count

func _process(_delta: float) -> void:
	# this is a massive waste of CPU cycles but we are in a rush here
	if visible and get_parent().visible:
		update_count_label()

func _on_next_button_pressed() -> void:
	StateManager.change_state(StateManager.ProgramStates.PAYMENT)
