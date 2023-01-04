extends Node2D

var bomb_radius = 10
var velocity = Vector2(50, -50)
var speed = 3

func _process(delta):
	velocity.y += LevelData.gravity * delta
	global_position.x += velocity.x * delta * speed
	global_position.y += velocity.y * delta * speed

func _on_area_2d_body_entered(body):
	explode()
	die()

func explode():
	var map_point = get_node("../TileMap").local_to_map(global_position)
	for x in range(bomb_radius):
		for y in range(bomb_radius):
			get_node("../TileMap").set_cell(0, Vector2i(map_point.x + x, map_point.y + y), -1)

func die():
	queue_free()
