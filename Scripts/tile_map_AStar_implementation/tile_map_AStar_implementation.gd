extends Node2D

class_name TilemapWithAStarImplementation

@onready var _tile_map:TileMap=$TileMap as TileMap
var _astar_instance:AStar2D

var _tilemap_crossable_cells:Array[Vector2i]
var _tilemap_block_cells:Array[Vector2i]

@export var block_layer_name:String
# Called when the node enters the scene tree for the first time.
func _ready():
	if scale.x!=1||scale.y!=1:
		scale=Vector2(1,1)
		push_error("the root part of this scene needs to be 1 on both axis, consider resizing the child tilemap")
	initialize_points()
	connect_points()
	#test_tilemap_cells()
	#test_astar_points()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass
func initialize_points():
	var block_layer_index:int=-1
	_astar_instance=AStar2D.new()
	for i in _tile_map.get_layers_count():
		if _tile_map.get_layer_name(i)==block_layer_name:
			block_layer_index=i
		else:
			_tilemap_crossable_cells.append_array(_tile_map.get_used_cells(i))
	if block_layer_index>-1:
		_tilemap_block_cells.append_array(_tile_map.get_used_cells(block_layer_index))
		for i in _tilemap_block_cells.size():
			_tilemap_crossable_cells.erase(_tilemap_block_cells[i])
	else :
		push_warning("Tilemap don´t have a layer named like the block_layer_name")
	for i in _tilemap_crossable_cells.size():
		_astar_instance.add_point(i,convert_tile_coordnates_to_world(_tilemap_crossable_cells[i]))
		pass
	pass

func connect_points():
	var check_distances:Vector2=_tile_map.tile_set.tile_size/2+Vector2i(1,1)
	
	for i in _astar_instance.get_point_count():
		connect_to_neighbor_points(i,check_distances,Vector2.RIGHT,true)
		connect_to_neighbor_points(i,check_distances,Vector2.DOWN,true)
	pass

func connect_to_neighbor_points(current_point_id:int,check_distances:Vector2,check_direction:Vector2,bidirectional:bool):
	
	var current_point_position:Vector2
	var checked_point_id:int
	var checked_point_position:Vector2
	
	current_point_position=_astar_instance.get_point_position(current_point_id)
	
	checked_point_id=_astar_instance.get_closest_point\
	(current_point_position+check_distances*check_direction)
	
	checked_point_position=_astar_instance.get_point_position(checked_point_id)
	
	if checked_point_id!=current_point_id &&\
		!((current_point_position.x != checked_point_position.x) &&\
		current_point_position.y != checked_point_position.y):
			#print(current_point_position-astar_instance.get_point_position(checked_point_id))
			_astar_instance.connect_points(current_point_id,checked_point_id,bidirectional)
	pass

func get_tile_position_from_index(index:int)->Vector2:
	return Vector2(_tilemap_crossable_cells[index]*_tile_map.tile_set.tile_size\
	+_tile_map.tile_set.tile_size/2)*_tile_map.scale

func convert_tile_coordnates_to_world(tile_coordnate:Vector2i):
	return Vector2(tile_coordnate*_tile_map.tile_set.tile_size\
	+_tile_map.tile_set.tile_size/2)*_tile_map.scale
	pass
#region Test_functions
#func test_tilemap_cells():
	#for i in _tilemap_crossable_cells.size():
		#print(get_tile_position_from_index(i))
		#pass
#func  test_astar_points():
	#for i in _astar_instance.get_point_count():
		#if _astar_instance.get_point_position(i).x<=32:
			#print(_astar_instance.get_point_position(i))
	#pass
#func _draw():
	#for i in _tilemap_crossable_cells.size():
		#draw_circle(convert_tile_coordnates_to_world(_tilemap_crossable_cells[i]),_tile_map.tile_set.tile_size.x*_tile_map.scale.x\
		#/4,Color.RED)
	#
	#var checked_point_position:Vector2
	#var connected_point_position:Vector2
	#
	#for i in _astar_instance.get_point_count():
		#draw_circle(_astar_instance.get_point_position(i),_tile_map.tile_set.tile_size.x*_tile_map.scale.x\
		#/6,Color.BLUE)
		#checked_point_position=_astar_instance.get_point_position(i)
		#for j in _astar_instance.get_point_connections(i).size():
			#connected_point_position=_astar_instance.get_point_position\
			#(_astar_instance.get_point_connections(i)[j])
			#draw_circle(checked_point_position+(connected_point_position-checked_point_position)/3,_tile_map.tile_set.tile_size.x*_tile_map.scale.x\
		#/9,Color.DARK_BLUE)
			#pass
#endregion
