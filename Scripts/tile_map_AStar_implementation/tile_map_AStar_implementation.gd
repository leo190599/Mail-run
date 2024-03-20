extends Node2D

@onready var tile_map:TileMap=$TileMap as TileMap
var astar_instance:AStar2D

var tilemap_crossable_cells:Array[Vector2i]
var tilemap_block_cells:Array[Vector2i]

@export var block_layer_name:String
# Called when the node enters the scene tree for the first time.
func _ready():
	initialize_points()
	connect_points()
	test_tilemap_cells()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass
func initialize_points():
	var block_layer_index:int=-1
	astar_instance=AStar2D.new()
	for i in tile_map.get_layers_count():
		if tile_map.get_layer_name(i)==block_layer_name:
			block_layer_index=i
		else:
			tilemap_crossable_cells.append_array(tile_map.get_used_cells(i))
	if block_layer_index>-1:
		tilemap_block_cells.append_array(tile_map.get_used_cells(block_layer_index))
		for i in tilemap_block_cells.size():
			tilemap_crossable_cells.erase(tilemap_block_cells[i])
	else :
		push_warning("Tilemap don´t have a layer named like the block_layer_name")
	for i in tilemap_crossable_cells.size():
		astar_instance.add_point(i,convert_tile_coordnates_to_world(tilemap_crossable_cells[i]))
		pass
	pass

func connect_points():
	var check_distances:Vector2=tile_map.tile_set.tile_size/2+Vector2i(1,1)
	
	for i in astar_instance.get_point_count():
		connect_to_neighbor_points(i,check_distances,Vector2.RIGHT,true)
		connect_to_neighbor_points(i,check_distances,Vector2.DOWN,true)
	pass

func connect_to_neighbor_points(current_point_id:int,check_distances:Vector2,check_direction:Vector2,bidirectional:bool):
	
	var current_point_position:Vector2
	var checked_point_id:int
	var checked_point_position:Vector2
	
	current_point_position=astar_instance.get_point_position(current_point_id)
	
	checked_point_id=astar_instance.get_closest_point\
	(current_point_position+check_distances*check_direction)
	
	checked_point_position=astar_instance.get_point_position(checked_point_id)
	
	if checked_point_id!=current_point_id &&\
		!((current_point_position.x != checked_point_position.x) &&\
		current_point_position.y != checked_point_position.y):
			#print(current_point_position-astar_instance.get_point_position(checked_point_id))
			astar_instance.connect_points(current_point_id,checked_point_id,bidirectional)
	pass

func get_tile_position_from_index(index:int)->Vector2:
	return Vector2(tilemap_crossable_cells[index]*tile_map.tile_set.tile_size\
	+tile_map.tile_set.tile_size/2)*tile_map.scale

func convert_tile_coordnates_to_world(tile_coordnate:Vector2i):
	return Vector2(tile_coordnate*tile_map.tile_set.tile_size\
	+tile_map.tile_set.tile_size/2)*tile_map.scale
	pass
#region Test_functions
func test_tilemap_cells():
	for i in tilemap_crossable_cells.size():
		#print(get_tile_position_from_index(i))
		pass
func _draw():
	for i in tilemap_crossable_cells.size():
		draw_circle(convert_tile_coordnates_to_world(tilemap_crossable_cells[i]),10,Color.RED)
	
	var checked_point_position:Vector2
	var connected_point_position:Vector2
	
	for i in astar_instance.get_point_count():
		draw_circle(astar_instance.get_point_position(i),6,Color.BLUE)
		checked_point_position=astar_instance.get_point_position(i)
		for j in astar_instance.get_point_connections(i).size():
			connected_point_position=astar_instance.get_point_position\
			(astar_instance.get_point_connections(i)[j])
			draw_circle(checked_point_position+(connected_point_position-checked_point_position)/4,6,Color.DARK_BLUE)
			pass
#endregion
