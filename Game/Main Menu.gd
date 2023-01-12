extends Button

var tilemap
var noise

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
	for x in range(100):
		for y in range(100):
			if noise.get_noise_2d(x,y) > 0:
				pass
			else:
				gen_tile(x, y, LevelData.blocks['STONE'])
			gen_bg(x, y, LevelData.backgrounds['STONE'])

func random_tile(tile_id):
	var answer = randi_range(0, tilemap.tile_set.get_source(tile_id).get_tiles_count() - 1)
	return Vector2(answer, 0)

func gen_tile(x, y, type):
	tilemap.set_cell(0, Vector2(x, y), type, random_tile(type))

func gen_bg(x, y, type):
	tilemap.set_cell(2, Vector2(x, y), type, random_tile(type))
