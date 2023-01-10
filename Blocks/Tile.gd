class_name Tile extends Resource

var tilemap
var max_health = 100
var health = max_health
var damaged = false
var position_in_tilemap = Vector2i(0, 0)
var position_in_atlas = Vector2i(0, 0)
var frames_since_mined_or_repaired = 0
var rotation


func process_tile():
	if health > max_health:
		damaged = true
	else:
		damaged = false
	# Increment number of frames
	frames_since_mined_or_repaired += 1
	# If tile hasn't been touched for 5 seconds
	if frames_since_mined_or_repaired >= 300:
			# Repair it and reset the timer
			if randi_range(1, 60) == 1:
			#frames_since_mined_or_repaired = 0
				var regen_num = max_health * 0.5
				health = clamp(health + regen_num, 0, max_health)
				update_tile_cracks()

func update_tile_cracks():
	var perc = 1.0*health/max_health
	print(perc)
	if perc <= .25: # [0, 50]
		tilemap.set_cell(1, position_in_tilemap, 1, Vector2(1,1))
	elif perc <= .5:
		tilemap.set_cell(1, position_in_tilemap, 1, Vector2(0,1))
	elif perc <= .75:
		tilemap.set_cell(1, position_in_tilemap, 1, Vector2(1,0))
	elif perc < 1:
		tilemap.set_cell(1, position_in_tilemap, 1, Vector2(0,0))
	elif perc == 1:
		tilemap.set_cell(1, position_in_tilemap, -1)
		LevelData.tile_list.erase(self)

func take_damage(damage):
	frames_since_mined_or_repaired = 0
	health = clamp(health - damage, 0, max_health)
	update_tile_cracks()
	if health == 0:
		break_tile()

func break_tile():
	var item = load("res://Blocks/Item.tscn").instantiate()
	tilemap.get_tree().get_first_node_in_group("level").add_child(item)
	item.global_position = tilemap.map_to_local(position_in_tilemap)
	item.get_node("Sprite2D").frame_coords = position_in_atlas
	var is_item = tilemap.get_cell_tile_data(0, position_in_tilemap).get_custom_data("is item")
	if is_item: # is an item
	
	else: # is a block
	var drop = tilemap.get_cell_tile_data(0, position_in_tilemap).get_custom_data("drops") # items name
	var item_drop = load("res://Items/" + drop).instantiate()
	tilemap.set_cell(1, position_in_tilemap, -1)
	tilemap.set_cell(0, position_in_tilemap, -1)
	LevelData.tile_list.erase(self)

func _ready():
	rotation = randi_range(1,4) * 90
