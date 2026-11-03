extends Node2D

func _state_changed(state):
	self.visible = (state == StateManager.ProgramStates.HOME)
	$HomeUILayer.visible = (state == StateManager.ProgramStates.HOME)
	

func _input(event: InputEvent) -> void:
	if self.visible and StateManager.currentProgramState == StateManager.ProgramStates.HOME:
		if(event != null):
			if(event is InputEventKey):
				StateManager.change_state(StateManager.ProgramStates.BACKGROND)
