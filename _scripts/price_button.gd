extends Panel

@export var toggle_mode : bool = false
@export var button_pressed : bool = false
@export var disabled : bool = false

signal pressed

func _on_button_pressed() -> void:
	pressed.emit()
	if toggle_mode:
		button_pressed = !button_pressed
		change_border(button_pressed)

func change_border(toggled : bool):
	if toggled == true:
		$Button.disabled = true
		
		# 1. Get the existing StyleBox from the Panel's theme overrides
		var current_stylebox = get_theme_stylebox("panel")
		
		# 2. Duplicate it to ensure you only change THIS specific panel's color
		if current_stylebox is StyleBoxFlat:
			var unique_stylebox = current_stylebox.duplicate()
			
			# 3. Change the border color
			unique_stylebox.border_color = Color.GREEN # Can use Color.from_string("#FF0000", Color.RED)
			
			# (Optional) Ensure the border width is greater than 0 so it's actually visible
			unique_stylebox.set_border_width_all(8) 
			
			# 4. Apply the modified unique StyleBox back to the panel
			add_theme_stylebox_override("panel", unique_stylebox)
	else:
		$Button.disabled = false
		# 1. Get the existing StyleBox from the Panel's theme overrides
		var current_stylebox = get_theme_stylebox("panel")
		
		# 2. Duplicate it to ensure you only change THIS specific panel's color
		if current_stylebox is StyleBoxFlat:
			var unique_stylebox = current_stylebox.duplicate()
			
			# 3. Change the border color
			unique_stylebox.border_color = Color.GOLD # Can use Color.from_string("#FF0000", Color.RED)
			
			# (Optional) Ensure the border width is greater than 0 so it's actually visible
			unique_stylebox.set_border_width_all(3) 
			
			# 4. Apply the modified unique StyleBox back to the panel
			add_theme_stylebox_override("panel", unique_stylebox)
