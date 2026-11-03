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
		
		$NameLabel.text = "Order Name: " + StateManager.customer_name
		
		$PrintedCopiesCount.text = "Print Copies: " + str(StateManager.print_count)
		$PaymentMethod.text = "Payment Method: " + StateManager.payment_method
		$TotalCost.text = "Total Cost: $%.2f"  % StateManager.total_cost
		
		add_child(StateManager.copied_background_list)
		
		if is_instance_valid(StateManager.copied_background_list):
			for child in StateManager.copied_background_list.get_node("VBoxContainer").get_children():
				child.disabled = true
				child.get_node("Panel").hide()
		
		show()
	else:
		if visible:
			if StateManager.copied_background_list != null:
				StateManager.copied_background_list.queue_free()
		
		hide()

func _on_next_button_pressed() -> void:
	StateManager.change_state(StateManager.ProgramStates.RECEIPT)

func _on_back_button_pressed() -> void:
	StateManager.change_state(StateManager.ProgramStates.NAME)

func _on_start_over_pressed() -> void:
	StateManager.change_state(StateManager.ProgramStates.NAME)
