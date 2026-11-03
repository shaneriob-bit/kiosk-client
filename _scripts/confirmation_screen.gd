extends CanvasLayer

func _state_changed(state):
	if state == StateManager.ProgramStates.CONFIRMATION:
		var email_fields = [
			$EmailContainer/Label,
			$EmailContainer/Label2,
			$EmailContainer/Label3,
			$EmailContainer/Label4,
			$EmailContainer/Label5
		]
		
		for field in email_fields:
			field.hide()
			
		for i in range (0, StateManager.email_count):
			email_fields[i].text = StateManager.emails[i]
			email_fields[i].show()
			
		$PrintedCopiesCount
		
		show()
	else:
		hide()

func _on_next_button_pressed() -> void:
	pass # Replace with function body.

func _on_back_button_pressed() -> void:
	StateManager.change_state(StateManager.ProgramStates.NAME)
