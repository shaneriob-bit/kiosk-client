extends Node

enum ProgramStates
{
	HOME,
	BACKGROND,
}

var currentProgramState = ProgramStates.HOME
var idle_timer : Timer

func _ready():
	idle_timer = Timer.new()
	self.add_to_group("StateListener")
	
	add_child(idle_timer)
	idle_timer.timeout.connect(_on_idle_timer_timeout)
	idle_timer.one_shot = true
	idle_timer.start(30)

func _on_idle_timer_timeout():
	change_state(ProgramStates.HOME)

func change_state(state):
	if state == ProgramStates.HOME:
		# reset EVERYTHING
		get_tree().reload_current_scene()
	else:
		get_tree().call_group("GroupListener", "_state_changed", state)

func _input(_event: InputEvent) -> void:
	# reset the timer
	idle_timer.start(30)
