extends TextureButton

var count : int = 0

func _on_toggled(toggled_on: bool) -> void:
	$Panel.visible = toggled_on
	if toggled_on == false:
		count = 0
		update_count_label()
	else:
		count = 1
		update_count_label()

func update_count_label():
	$Panel/Count.text = str(count)

func _on_up_button_pressed() -> void:
	count += 1
	update_count_label()

func _on_down_button_pressed() -> void:
	if count > 1:
		count -= 1
		update_count_label()

func get_count():
	return count
