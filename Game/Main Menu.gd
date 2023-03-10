extends Button

var tilemap
var noise
var width = 200
var height = 200
var lights = []

func _ready():
	noise = FastNoiseLite.new()
	noise.noise_type = 0
	noise.seed = 0#randi()
	noise.frequency = .05
	noise.fractal_octaves = 2

func _on_pressed(): # Generate the world!
	visible = false
	disabled = true
	var game = load("res://Game/Main.tscn").instantiate()
	get_parent().add_child(game)
	tilemap = game.get_node("Level/TileMap")
	for x in range(-width/2, width/2):
		for y in range(-height/2, height/2):
			if noise.get_noise_2d(x,y) > 0:
				# empty
				if randi_range(1, 100) == -1:
					gen_tile(x, y, LevelData.backgrounds['AIR'])
					var light = load("res://Light.tscn").instantiate()
					light.global_position = tilemap.map_to_local(Vector2(x,y))# + Vector2(LevelData.tile_size/2, LevelData.tile_size/2)
					tilemap.get_parent().add_child(light)
					lights.append(light)
				else:
					gen_bg(x, y, LevelData.backgrounds['STONE'])
			else:
				gen_bg(x, y, LevelData.backgrounds['STONE'])
				gen_tile(x, y, LevelData.blocks['STONE'])
	gen_bg(28, 20, LevelData.backgrounds['AIR'])
	gen_tile(28, 20, LevelData.blocks['AIR'])

func is_empty(x,y):
	var pos = Vector2(x, y)
	var tile_id = tilemap.get_cell_source_id(0, pos)
	var bg_id = tilemap.get_cell_source_id(2, pos)
	if (tile_id == -1) and (bg_id == -1):
		pass

func random_tile(tile_id):
	if tile_id == -1:
		return Vector2(0, 0)
	var answer = randi_range(0, tilemap.tile_set.get_source(tile_id).get_tiles_count() - 1)
	return Vector2(answer, 0)

func gen_tile(x, y, type):
	if type == -1:
		tilemap.set_cell(0, Vector2(x, y), type)
	else:
		tilemap.set_cell(0, Vector2(x, y), type, random_tile(type))

func gen_bg(x, y, type):
	if type == -1:
		tilemap.set_cell(2, Vector2(x, y), type)
	else:
		tilemap.set_cell(2, Vector2(x, y), type, random_tile(type))
