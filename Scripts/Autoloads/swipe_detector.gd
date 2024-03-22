extends Node

signal swipe_ocurred(direction:Vector2,lenght:float)

var screen_touch_start_position:Vector2
var screen_touch_end_position:Vector2

var min_swipe_lenght=50

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	detect_swipe()
	pass

func detect_swipe():
	if Input.is_action_just_pressed("Touch") :
		screen_touch_start_position=get_viewport().get_mouse_position()
	if Input.is_action_just_released("Touch"):
		screen_touch_end_position=get_viewport().get_mouse_position()
		if screen_touch_start_position.distance_to(screen_touch_end_position)>=min_swipe_lenght:
			swipe_ocurred.emit((screen_touch_end_position-screen_touch_start_position).normalized(),
			screen_touch_start_position.distance_to(screen_touch_end_position))
	pass
