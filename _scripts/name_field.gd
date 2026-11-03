extends CanvasLayer

@onready var email_fields = [
	$VBoxContainer/EmailContainer/LineEdit,
	$VBoxContainer/EmailContainer/LineEdit2,
	$VBoxContainer/EmailContainer/LineEdit3,
	$VBoxContainer/EmailContainer/LineEdit4,
	$VBoxContainer/EmailContainer/LineEdit5
]

func _state_changed(state):
	if state == StateManager.ProgramStates.NAME:
		# email stuff
		if StateManager.email_count <= 0:
			$VBoxContainer/EmailContainer.hide()
		else:
			$VBoxContainer/EmailContainer.show()
			for child in $VBoxContainer/EmailContainer.get_children():
				if child is LineEdit:
					child.hide()
			
			for i in range(0, StateManager.email_count):
				email_fields[i].show()
		
		show()
	else:
		if visible:
			StateManager.emails = []
			for child in email_fields:
				if child.visible == true:
					StateManager.emails.append(child.text)
		
		hide()

func _on_back_button_pressed() -> void:
	StateManager.change_state(StateManager.ProgramStates.PAYMENT)
	
func _on_next_button_pressed() -> void:
	StateManager.change_state(StateManager.ProgramStates.CONFIRMATION)
	
func _process(_delta: float) -> void:
	var box_empty = false
	
	for child in email_fields:
		if child.visible == true:
			if child.text == "":
				box_empty = true
	
	if $VBoxContainer/NameContainer/Label.text == "":
		box_empty = true
		
	if box_empty == true:
		$NextButton.hide()
		$ButtonDisabledInfo.show()
	else:
		$NextButton.show()
		$ButtonDisabledInfo.hide()
