extends Area2D
class_name Player

enum MOVE_DIRECTION {LEFT,RIGHT,UP,DOWN,NONE}

var pointing_direction:MOVE_DIRECTION=MOVE_DIRECTION.NONE
var next_pointing_direction:MOVE_DIRECTION=MOVE_DIRECTION.NONE

var level_tilemap_AStar_Inplementation:TilemapWithAStarImplementation

var current_node_index:int
var next_node_index:int=-1
var current_node_position:Vector2
var next_node_position:Vector2

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
	pass

func _physics_process(delta):
	set_next_node()
	set_movement_direction()
	move()
	update_current_node()

func initialize_position():
	current_node_index=level_tilemap_AStar_Inplementation._astar_instance.get_closest_point(position)
	current_node_position=level_tilemap_AStar_Inplementation._astar_instance.get_point_position(current_node_index)
	position=current_node_position
	pass

func on_swipe_ocurred(swipe_direction:Vector2,swipe_lenght:float):
	if abs(swipe_direction.x)>abs(swipe_direction.y):
		if swipe_direction.x>0:
			next_pointing_direction=MOVE_DIRECTION.RIGHT
		else :
			next_pointing_direction=MOVE_DIRECTION.LEFT
	else :
		if swipe_direction.y<0:
			next_pointing_direction=MOVE_DIRECTION.UP
		else :
			next_pointing_direction=MOVE_DIRECTION.DOWN
	if pointing_direction==MOVE_DIRECTION.NONE:
		pointing_direction=next_pointing_direction

func set_movement_direction():
	if next_node_index<0:
		return
	vel_direction=next_node_position-current_node_position
	vel_direction=vel_direction.normalized()

func set_next_node():
	var partical_next_node_index:int
	if pointing_direction==MOVE_DIRECTION.NONE:
		return
	if position != current_node_position:
		#checks if the desired direction is oposite to the current direction and if it is
		#apply it
		match next_pointing_direction:
			MOVE_DIRECTION.RIGHT:
				if pointing_direction==MOVE_DIRECTION.LEFT:
					pointing_direction=next_pointing_direction
					swipe_current_next_node()
			MOVE_DIRECTION.LEFT:
				if pointing_direction==MOVE_DIRECTION.RIGHT:
					pointing_direction=next_pointing_direction
					swipe_current_next_node()
			MOVE_DIRECTION.UP:
				if pointing_direction==MOVE_DIRECTION.DOWN:
					pointing_direction=next_pointing_direction
					swipe_current_next_node()
			MOVE_DIRECTION.DOWN:
				if pointing_direction==MOVE_DIRECTION.UP:
					pointing_direction=next_pointing_direction
					swipe_current_next_node()
		return
	#checks if is possible to apply the desired direction to walk, if it is, the current
	#direction turns into the desired direction
	match next_pointing_direction:
		MOVE_DIRECTION.RIGHT:
			partical_next_node_index=level_tilemap_AStar_Inplementation.\
			get_neighbour_point_id_from_direction(current_node_index,Vector2.RIGHT)
		MOVE_DIRECTION.LEFT:
			partical_next_node_index=level_tilemap_AStar_Inplementation.\
			get_neighbour_point_id_from_direction(current_node_index,Vector2.LEFT)
		MOVE_DIRECTION.UP:
			partical_next_node_index=level_tilemap_AStar_Inplementation.\
			get_neighbour_point_id_from_direction(current_node_index,Vector2.UP)
		MOVE_DIRECTION.DOWN:
			partical_next_node_index=level_tilemap_AStar_Inplementation.\
			get_neighbour_point_id_from_direction(current_node_index,Vector2.DOWN)
	if partical_next_node_index>=0:
		pointing_direction=next_pointing_direction
		next_node_index=partical_next_node_index
		
		next_node_position=level_tilemap_AStar_Inplementation.\
		_astar_instance.get_point_position(next_node_index)
		return
	#if is not possible to walk on the desired direction it will apply the current direction
	match pointing_direction:
		MOVE_DIRECTION.RIGHT:
			partical_next_node_index=level_tilemap_AStar_Inplementation.\
			get_neighbour_point_id_from_direction(current_node_index,Vector2.RIGHT)
		MOVE_DIRECTION.LEFT:
			partical_next_node_index=level_tilemap_AStar_Inplementation.\
			get_neighbour_point_id_from_direction(current_node_index,Vector2.LEFT)
		MOVE_DIRECTION.UP:
			partical_next_node_index=level_tilemap_AStar_Inplementation.\
			get_neighbour_point_id_from_direction(current_node_index,Vector2.UP)
		MOVE_DIRECTION.DOWN:
			partical_next_node_index=level_tilemap_AStar_Inplementation.\
			get_neighbour_point_id_from_direction(current_node_index,Vector2.DOWN)
	if partical_next_node_index>=0:
		next_node_index=partical_next_node_index
		
		next_node_position=level_tilemap_AStar_Inplementation.\
		_astar_instance.get_point_position(next_node_index)
func move():
	if next_node_index<0:
		return
	position+=vel_direction*speed
	
	position.x=clamp(position.x,\
	min(current_node_position.x,next_node_position.x),
	max(current_node_position.x,next_node_position.x))
	
	position.y=clamp(position.y,\
	min(current_node_position.y,next_node_position.y),
	max(current_node_position.y,next_node_position.y))

func update_current_node():
	if next_node_index<0:
		return
	if position==next_node_position:
		current_node_index=next_node_index
		current_node_position=next_node_position
func swipe_current_next_node():

	var partial_current_node_index:int=-1
	var partial_current_node_position:Vector2=Vector2.ZERO
	
	partial_current_node_index=current_node_index
	partial_current_node_position=current_node_position
	
	current_node_index=next_node_index
	current_node_position=next_node_position
	
	
	next_node_index=partial_current_node_index
	next_node_position=partial_current_node_position
	pass
#region Tests
#func test_input():
	#if Input.is_action_just_pressed("Touch"):
		#position=get_viewport().get_mouse_position()
	#pass
#endregion
