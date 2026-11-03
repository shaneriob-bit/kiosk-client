extends CanvasLayer

func _state_changed(state):
	if state == StateManager.ProgramStates.RECEIPT:
		
		show()
	else:
		hide()


func _on_holding_reciept_button_pressed() -> void:
	$RecieptPrinting.hide()
	$Instructions.show()

func _on_start_over_pressed() -> void:
	StateManager.change_state(StateManager.ProgramStates.HOME)
