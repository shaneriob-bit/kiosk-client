extends Node2D

var scrolling_image_array : Array[Node]
var screen_center : Vector2 

func _ready() -> void:
	screen_center = get_viewport_rect().size / 2.0
	
	scrolling_image_array = get_children()
	for i in range(scrolling_image_array.size()):
		var sprite = scrolling_image_array[i]
		var position_x = (1024 * i) + screen_center.x - 2048
		sprite.position = Vector2(position_x, 512)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
