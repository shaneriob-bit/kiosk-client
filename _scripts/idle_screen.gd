extends CanvasLayer

func update_seconds(seconds : int):
	$Panel/Label.text = "Are you still ordering?\nYou will be automatically signed out in " + str(seconds) + " seconds.\nPress any key or move the mouse to continue."

func _ready() -> void:
	StateManager.idle_screen = self
