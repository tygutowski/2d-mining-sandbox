extends Node

enum blocks {AIR,DIRT,STONE,IRON_ORE}
@onready var tilemap = get_tree().get_first_node_in_group("tilemap")
var tile_list = []
var gravity = 500

func _process(_delta):
	for tile in tile_list:
		tile.process_tile()
