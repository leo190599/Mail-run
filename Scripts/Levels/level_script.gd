extends Node2D

@onready var tilemap:TilemapWithAStarImplementation=$TileMapWithNavigationPoints as TilemapWithAStarImplementation
@onready var player:Player=$Player as Player

# Called when the node enters the scene tree for the first time.
func _ready():
	player.level_tilemap_AStar_Inplementation=tilemap
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
