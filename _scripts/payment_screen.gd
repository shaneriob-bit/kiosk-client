extends CanvasLayer

const CONFIG_PATH = "user://config/pricing.json"

@onready var hbox = $HBoxContainer

var bulk_discount_mode: bool = false
var print_costs: Array = [9.99, 9.99, 8.99, 7.99, 6.99, 5.99, 4.99, 3.99, 2.99]
var current_selected_prints: int = 0
var buttons: Array[Button] = []

func _ready() -> void:
	load_pricing_config()
	setup_buttons()
	update_button_texts()

# Reads the pricing JSON and applies it
func load_pricing_config() -> void:
	if not FileAccess.file_exists(CONFIG_PATH):
		push_warning("Pricing config not found at %s, using defaults." % CONFIG_PATH)
		return
		
	var file = FileAccess.open(CONFIG_PATH, FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	
	var json = JSON.new()
	var error = json.parse(content)
	if error == OK:
		var data = json.get_data()
		if typeof(data) == TYPE_DICTIONARY:
			if data.has("bulk-discount-mode"):
				bulk_discount_mode = data["bulk-discount-mode"]
			if data.has("print-costs") and typeof(data["print-costs"]) == TYPE_ARRAY:
				print_costs = data["print-costs"]
	else:
		push_error("Failed to parse pricing JSON.")

# Gathers the buttons and connects their pressed signals
func setup_buttons() -> void:
	# Ensure we have exactly 10 children to work with
	var children = hbox.get_children()
	for i in range(min(10, children.size())):
		var btn = children[i] as Button
		if btn:
			buttons.append(btn)
			# Bind the index (amount of prints) to the signal callback
			btn.pressed.connect(_on_button_pressed.bind(i))

# Calculates the total cost for a specific number of prints
func get_total_cost(num_prints: int) -> float:
	if num_prints == 0:
		return 0.0
		
	# Cap the index to the size of our pricing array to prevent crashes
	var max_index = min(num_prints, print_costs.size())
	var total: float = 0.0
	
	if bulk_discount_mode:
		# e.g., 3 prints uses the 3rd array value as a flat unit price for ALL 3 prints
		var unit_price = float(print_costs[max_index - 1])
		total = unit_price * num_prints
	else:
		# e.g., 3 prints adds the 1st, 2nd, and 3rd array values together
		for i in range(max_index):
			total += float(print_costs[i])
			
	return total

# Refreshes the text on all buttons relative to the current selection
func update_button_texts() -> void:
	var current_cost = get_total_cost(current_selected_prints)
	
	for i in range(buttons.size()):
		var btn = buttons[i]
		var target_cost = get_total_cost(i)
		var price_diff = target_cost - current_cost
		
		var title_text = "No Prints" if i == 0 else str(i)
		var price_text = ""
		
		# Format the relative price text
		if abs(price_diff) < 0.01:
			price_text = "" # No price modifier shown for the currently selected option
		elif price_diff > 0:
			price_text = "+ $%.2f" % price_diff
		else:
			price_text = "- $%.2f" % abs(price_diff)
		
		# Apply the text (only add a newline if there is price text to show)
		if price_text == "":
			btn.text = title_text
		else:
			btn.text = "%s\n%s" % [title_text, price_text]
			
		# Optional: visually highlight the selected button
		btn.disabled = (i == current_selected_prints)

# Triggered when any print quantity button is pressed
func _on_button_pressed(prints_amount: int) -> void:
	current_selected_prints = prints_amount
	update_button_texts()
	print("User selected %d prints. Total Cost: $%.2f" % [prints_amount, get_total_cost(prints_amount)])
