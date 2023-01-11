extends Button

var tilemap

func _on_pressed(): # Generate the world!
	disabled = true
	var game = load("res://Game/Main.tscn").instantiate()
	get_parent().add_child(game)
	tilemap = game.get_node("Level/TileMap")
	for x in range(100):
		for y in range(10):
			gen_cell(x, y, LevelData.blocks.DIRT)
			gen_cell(x, y+10, LevelData.blocks.STONE)

func random_tile(tile_id):
	var answer = randi_range(0, tilemap.tile_set.get_source(tile_id).get_tiles_count() - 1)
	return Vector2(answer, 0)

func gen_cell(x, y, type):
	tilemap.set_cell(0, Vector2(x, y), type, random_tile(type))
