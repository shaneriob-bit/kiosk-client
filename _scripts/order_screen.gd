extends Control

func _state_changed(state):
	var texture_buttons = []
	if state == StateManager.ProgramStates.BACKGROND:
		self.visible = true
		get_parent().visible = true
	else:
		self.visible = false
		get_parent().visible = true

	for child in $BackgroundSelection/VBoxContainer.get_children():
		if child is GridContainer:
			for button in child.get_children():
				if button is TextureButton:
					if button.button_pressed == true:
						texture_buttons.append(button)
						
	if $CustomBackgroundPanel.get_node_or_null("CustomBackground") != null:
		if $CustomBackgroundPanel/CustomBackground.count > 0:
			texture_buttons.append($CustomBackgroundPanel/CustomBackground)
	
	# add them to the state manager array
	for texture_button in texture_buttons:
		StateManager.selected_backgrounds.append(texture_button)
	
	update_count_label()

func update_count_label():
	var total_count = 0
	
	StateManager.total_photos = total_count
	
	var texture_buttons = []
	
	for child in $BackgroundSelection/VBoxContainer.get_children():
		if child is GridContainer:
			for button in child.get_children():
				if button is TextureButton:
					texture_buttons.append(button)

	if $CustomBackgroundPanel.get_node_or_null("CustomBackground") != null:
		if $CustomBackgroundPanel/CustomBackground.count > 0:
			texture_buttons.append($CustomBackgroundPanel/CustomBackground)

	for texture_button in texture_buttons:
		total_count += texture_button.get_count()
	
	$PhotoCountLabel.text = "You will be taking\n" + str(total_count) + " photo(s)" 
	
	$NextButton.visible = total_count > 0
	$DisabledButtonInfo.visible = total_count <= 0
	
	$PhotoCost.text = "$%.2f" % (StateManager.base_price * total_count)

func _process(_delta: float) -> void:
	# this is a massive waste of CPU cycles but we are in a rush here
	if visible and get_parent().visible:
		update_count_label()

func _on_next_button_pressed() -> void:
	StateManager.change_state(StateManager.ProgramStates.PAYMENT)

func _on_exit_preview_pressed() -> void:
	$PreviewPanel.hide()

func _on_custom_backgrounds_pressed() -> void:
	$CustomBackgroundPanel.show()

func _on_exit_custom_background_pressed() -> void:
	$CustomBackgroundPanel.hide()

func _on_start_over_pressed() -> void:
	StateManager.change_state(StateManager.ProgramStates.HOME)
