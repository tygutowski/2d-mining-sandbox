extends PointLight2D

@onready var raycast = get_node("RayCast2D")
@onready var tilemap = get_tree().get_first_node_in_group("tilemap")

func check_all_positions():
	var positions = []
	for i in range(36):
		raycast.force_raycast_update()
		print("is_updated")
		if raycast.is_colliding():
			print("is_colliding")
			var collision_point = raycast.get_collision_point()
			var tile = tilemap.local_to_map(collision_point)
			positions.append(tile)
		raycast.rotation += deg_to_rad(10)
	return positions
