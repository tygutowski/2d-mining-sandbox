extends Node

var blocks = {
	'AIR': -1,
	'DIRT': 1,
	'STONE': 2,
	'IRON_ORE': 3}
var backgrounds = {
	'AIR': -1,
	'STONE': 1002}
@onready var tilemap = get_tree().get_first_node_in_group("tilemap")
var tile_list = []
var gravity = 500

func _process(_delta):
	for tile in tile_list:
		tile.process_tile()
