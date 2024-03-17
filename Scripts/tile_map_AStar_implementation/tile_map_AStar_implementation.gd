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
	print(tile_map.get_used_rect())
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
#endregion
	for i in tilemap_crossable_cells.size():
		draw_circle(convert_tile_coordnates_to_world(tilemap_crossable_cells[i]),5,Color.RED)
	for i in astar_instance.get_point_count():
		draw_circle(astar_instance.get_point_position(i),3,Color.BLUE)
