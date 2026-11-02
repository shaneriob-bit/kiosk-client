extends HBoxContainer

var package_button_scene = preload("res://_scenes/price_button.tscn")

@export var promotion_mode : bool = true
var base_print_price = 9.99 # to be declared in json

# for packages of quantities at or above this amount, discount by this percent.
var discounts = {
	4 : 0.1,
	6 : 0.2,
	8 : 0.3
}

# array of quantity packages, to be replaced by json.
var quantities = [2, 4, 6, 8]
