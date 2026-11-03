extends CanvasLayer

func _state_changed(state):
	if state == StateManager.ProgramStates.RECEIPT:
		
		show()
	else:
		hide()
