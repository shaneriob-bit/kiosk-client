extends TabBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var longest_string_length = 0
	for i in tab_count:
		var tab_text = get_tab_title(i)
		if tab_text.length() > longest_string_length:
			longest_string_length = tab_text.length()
			
	for i in tab_count:
		var tab_text = get_tab_title(i)
		if tab_text.length() < longest_string_length:
			for k in (longest_string_length - tab_text.length()):
				set_tab_title(i, get_tab_title(i) + " ")
