extends Node

enum ProgramStates
{
	HOME,
	BACKGROND,
	PAYMENT,
	NAME,
	CONFIRMATION
}

var currentProgramState = ProgramStates.HOME
var idle_timer : Timer

var idle_alert = false

var idle_screen : CanvasLayer

var total_photos = 0

var base_price = 9.99

var print_count = 0
var email_count = 0

var total_cost = 0

var emails = [
	
]

var payment_method = null

var selected_backgrounds = [
	
]

func _ready():
	idle_timer = Timer.new()
	self.add_to_group("GroupListener")
	
	add_child(idle_timer)
	idle_timer.timeout.connect(_on_idle_timer_timeout)
	idle_timer.one_shot = true

func _on_idle_timer_timeout():
	change_state(ProgramStates.HOME)

func change_state(state):
	currentProgramState = state
	
	if state == ProgramStates.HOME:
		# reset EVERYTHING
		selected_backgrounds = []
		get_tree().reload_current_scene()
	else:
		# we are no longer home, start the idle timer
		idle_timer.start(30)
		get_tree().call_group("GroupListener", "_state_changed", state)


func _input(_event: InputEvent) -> void:
	# reset the timer
	idle_timer.start(30)

func get_idle_time_left():
	return idle_timer.wait_time
	
func set_idle_screen(screen):
	idle_screen = screen

func _process(_delta: float) -> void:
	# maybe consider changing this to every second
	if idle_timer.time_left < 10 and currentProgramState != ProgramStates.HOME:
		if idle_screen != null:
			idle_screen.update_seconds(idle_timer.time_left)
			idle_screen.visible = true
	else:
		if idle_screen != null:
			idle_screen.visible = false
