extends Control

func _state_changed(state):
	if state != StateManager.ProgramStates.HOME:
		self.visible = true
