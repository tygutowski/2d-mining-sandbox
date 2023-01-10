extends Node

@onready var tilemap = get_node("../Main/Level/TileMap")
var tile_list = []
var gravity = 500

func _process(_delta):
	for tile in tile_list:
		tile.process_tile()
