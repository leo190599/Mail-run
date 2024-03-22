extends Area2D
class_name Player

enum MOVE_DIRECTION {LEFT,RIGHT,UP,DOWN,NONE}

var pointing_direction:MOVE_DIRECTION=MOVE_DIRECTION.NONE

var level_tilemap_AStar_Inplementation:TilemapWithAStarImplementation

var current_node_index:int
var next_node_index:int

var vel_direction:Vector2=Vector2(0,0)
var speed:float=3
# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().current_scene.ready
	if level_tilemap_AStar_Inplementation==null:
		push_error("Level is not linking a TilemapWithAStarImplementation to player")
	initialize_position()
	SwipeDetector.swipe_ocurred.connect(on_swipe_ocurred)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#test_input()
	pass

func _physics_process(delta):
	set_movement_direction()
	move()

func initialize_position():
	current_node_index=level_tilemap_AStar_Inplementation._astar_instance.get_closest_point(position)
	position=level_tilemap_AStar_Inplementation._astar_instance.get_point_position(current_node_index)
	pass

func on_swipe_ocurred(swipe_direction:Vector2,swipe_lenght:float):
	if abs(swipe_direction.x)>abs(swipe_direction.y):
		if swipe_direction.x>0:
			pointing_direction=MOVE_DIRECTION.RIGHT
		else :
			pointing_direction=MOVE_DIRECTION.LEFT
	else :
		if swipe_direction.y>0:
			pointing_direction=MOVE_DIRECTION.UP
		else :
			pointing_direction=MOVE_DIRECTION.DOWN

func set_movement_direction():
	
	match pointing_direction:
		MOVE_DIRECTION.UP:
			vel_direction.x=0
			vel_direction.y=1
		MOVE_DIRECTION.DOWN:
			vel_direction.x=0
			vel_direction.y=-1
		MOVE_DIRECTION.RIGHT:
			vel_direction.x=1
			vel_direction.y=0
		MOVE_DIRECTION.LEFT:
			vel_direction.x=-1
			vel_direction.y=0
		_:
			vel_direction.x=0
			vel_direction.y=0

func move():
	##Make use of the tilemap
	position+=vel_direction*speed
	pass
pass

#region Tests
#func test_input():
	#if Input.is_action_just_pressed("Touch"):
		#position=get_viewport().get_mouse_position()
	#pass
#endregion
