extends CanvasLayer

var prints_count = 0
var emails_count = 0
var photo_count = 0

var print_prices = [
	0.00,
	8.99,
	8.99,
	8.99,
	8.99,
	8.99,
	7.99,
	7.99,
	6.99
]

var email_prices = [
	0.00,
	10.00,
	1.00,
	1.00,
	0.50,
	0.50,
]

func _ready():
	$Control/PrintsContainer/PrintsAmount.text = str(prints_count)
	$Control/EmailContainer/EmailAmount.text = str(emails_count)
	update_print_amount_labels()
	update_email_amount_labels()
	update_total_labels()
	
	for confirmation_dialog in get_children():
		if confirmation_dialog is ConfirmationDialog:
			var label: Label = confirmation_dialog.get_label()
			if label:
				label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

func update_print_amount_labels():
	if prints_count < 8:
		$Control/PrintsContainer/Add/Label.text = ("+ $%.2f" % (print_prices[prints_count + 1] * photo_count))
		$Control/PrintsContainer/Add/Label.show()
	else:
		$Control/PrintsContainer/Add/Label.hide()
	
	if print_prices.get(prints_count) != null and prints_count > 0:
		$Control/PrintsContainer/Subtract/Label.text = "- $%.2f" % (print_prices.get(prints_count)  * photo_count)
		$Control/PrintsContainer/Subtract/Label.show()
	else:
		$Control/PrintsContainer/Subtract/Label.hide()

func update_email_amount_labels():
	if emails_count < 5:
		$Control/EmailContainer/Add/Label.text = "+ $%.2f" % (email_prices[emails_count + 1] * photo_count)
		$Control/EmailContainer/Add/Label.show()
	else:
		$Control/EmailContainer/Add/Label.hide()
	
	if print_prices.get(emails_count) != null and emails_count > 0:
		$Control/EmailContainer/Subtract/Label.text = "- $%.2f" % (email_prices.get(emails_count) * photo_count)
		$Control/EmailContainer/Subtract/Label.show()
	else:
		$Control/EmailContainer/Subtract/Label.hide()

func get_print_total():
	var total = 0
	for i in range(0, prints_count + 1):
		total += print_prices[i]
	
	return total
	
func get_email_total():
	var total = 0
	for i in range(0, emails_count + 1):
		total += email_prices[i]
		
	return total

func update_total_labels():
	$Control/TotalsLabel.text = "Prints (x" + str(prints_count) + "): $%.2f" % get_print_total()
	$Control/TotalsLabel.text += "\nEmails (x" + str(emails_count) + "): $%.2f" % get_email_total()
	$Control/TotalsLabel.text += "\nBase price per photo: $%.2f" % StateManager.base_price
	$Control/TotalsLabel.text += "\nMultiplied by " + str(photo_count) + " photos"
	$Control/TotalsLabel.text += "\nTotal: $%.2f" % ((get_print_total() + get_email_total()) * photo_count + (StateManager.base_price * photo_count))

func _on_subtract_pressed() -> void:
	if prints_count > 0:
		prints_count -= 1
	
	update_print_amount_labels()
	
	$Control/PrintsContainer/PrintsAmount.text = str(prints_count)
	
	update_total_labels()
	
func _on_add_pressed() -> void:
	if prints_count < 8:
		prints_count += 1
		
	update_print_amount_labels()
	
	$Control/PrintsContainer/PrintsAmount.text = str(prints_count)
	
	update_total_labels()

func _on_email_subtract_pressed() -> void:
	if emails_count > 0:
		emails_count -= 1
	
	update_email_amount_labels()
	
	$Control/EmailContainer/EmailAmount.text = str(emails_count)

	update_total_labels()
func _on_email_add_pressed() -> void:
	if emails_count < 5:
		emails_count += 1
		
	update_email_amount_labels()
	
	$Control/EmailContainer/EmailAmount.text = str(emails_count)

	update_total_labels()

func _state_changed(state):
	photo_count = StateManager.total_photos
	
	$Control/PrintsContainer/PrintsAmount.text = str(prints_count)
	$Control/EmailContainer/EmailAmount.text = str(emails_count)
	update_print_amount_labels()
	update_email_amount_labels()
	update_total_labels()
	
	if state == StateManager.ProgramStates.NAME and visible == true:
		StateManager.email_count = emails_count
	
	if state == StateManager.ProgramStates.PAYMENT:
		for child : TextureButton in StateManager.selected_backgrounds:
			child.disabled = true
			child.get_node("Panel").position += Vector2()
			child.reparent($Control/BackgroundsContainer/VBoxContainer)
		show()
	elif state == StateManager.ProgramStates.BACKGROND:
		# go back to background
		for child : TextureButton in $Control/BackgroundsContainer/VBoxContainer.get_children():
			child.disabled = false
			child.reparent(child.original_parent)
			child.show()
		hide()
	else:
		hide()


func _process(_delta: float) -> void:
	if StateManager.currentProgramState == StateManager.ProgramStates.PAYMENT:
		var photo_total = 0
		for child in $Control/BackgroundsContainer/VBoxContainer.get_children():
			if child.count == 0 and child.visible == true:
				child.button_pressed = false
				child.hide()
			else:
				photo_total += child.count
	
		photo_count = photo_total
		
		$Control/PrintsContainer/PrintsAmount.text = str(prints_count)
		$Control/EmailContainer/EmailAmount.text = str(emails_count)
		update_print_amount_labels()
		update_email_amount_labels()
		update_total_labels()
		
		if photo_count <= 0:
			StateManager.change_state(StateManager.ProgramStates.BACKGROND)

func _on_next_button_pressed() -> void:
	StateManager.change_state(StateManager.ProgramStates.NAME)

func _on_back_button_pressed() -> void:
	StateManager.change_state(StateManager.ProgramStates.BACKGROND)

func _unhandled_input(event: InputEvent) -> void:
	if StateManager.ProgramStates.PAYMENT:
		if event is InputEventKey:
			if event.pressed and not event.echo:
				if event.keycode == KEY_F1:
					$RemoveBackgroundConfirm.show()
				elif event.keycode == KEY_F2:
					$BackToBackgroundConfirmation.show()
					
func there_can_only_be_one_payment_method(button : Node):
	for child in button.get_parent().get_children():
		if child != button and child.button_pressed == true:
			child._on_button_pressed()
			
func _on_cash_pressed() -> void:
	there_can_only_be_one_payment_method($Control/VBoxContainer/Cash)
	
func _on_credit_pressed() -> void:
	there_can_only_be_one_payment_method($Control/VBoxContainer/Credit)

func _on_debit_pressed() -> void:
	there_can_only_be_one_payment_method($Control/VBoxContainer/Debit)

func _on_check_pressed() -> void:
	there_can_only_be_one_payment_method($Control/VBoxContainer/Check)
	
	
	
	
	


func _on_button_pressed() -> void:
	pass # Replace with function body.
