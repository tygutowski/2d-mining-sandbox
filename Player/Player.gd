extends CharacterBody2D
@onready var hand_pivot = get_node("HandPivot")
@onready var hand = hand_pivot.get_node("Hand")
@onready var anim_tree = get_node("AnimationTree")
@onready var gun = hand.get_node("Gun")
var arm_radius = 5
var weapon_range = 100
const SPEED = 150.0
const JUMP_VELOCITY = -200.0

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += LevelData.gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("run_left", "run_right")
	if direction:
		velocity.x = direction * SPEED
		anim_tree.set("parameters/run_or_idle/current", 0) #run
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		anim_tree.set("parameters/run_or_idle/current", 1) #idle
	move_and_slide()

func _process(delta):
	var mouse_pos = get_global_mouse_position()
	var distance = hand_pivot.global_position.distance_to(mouse_pos)
	var mouse_dir = (mouse_pos-hand_pivot.global_position).normalized()
	if distance > arm_radius:
		mouse_pos = hand_pivot.global_position + (mouse_dir * arm_radius)
	hand.global_position = mouse_pos
	
	
	gun.rotation = get_angle_to(get_global_mouse_position())
	gun.global_position = hand.global_position
	if (gun.rotation <= 0 && gun.rotation >= -1.57079633): # [-1, 0]
		gun.get_node("Sprite").flip_v = false
	elif (gun.rotation >= 0 && gun.rotation <= 1.57079633): # [0, 1]
		gun.get_node("Sprite").flip_v = false
	elif (gun.rotation >= 1.57079633 && gun.rotation <= 3.14159265): # [1, 2]
		gun.get_node("Sprite").flip_v = true
	elif (gun.rotation >= -3.14159265 && gun.rotation <= -1.57079633): # [-2, -1]
		gun.get_node("Sprite").flip_v = true
	
	if Input.is_action_pressed("shoot"):
		gun.get_node("Line2D").visible = true
		gun.get_node("RayCast2D").enabled = true
		gun.get_node("RayCast2D").force_raycast_update()
		var target = gun.get_node("RayCast2D").get_collider()
		if target && target.is_class("TileMap"):
			var collision_point = gun.get_node("RayCast2D").get_collision_point()
			var point = collision_point - gun.get_node("RayCast2D").get_collision_normal()
			gun.get_node("Line2D").set_point_position(1,Vector2(0, (gun.get_node("Line2D").global_position).distance_to(collision_point)))
			var map_point = target.local_to_map(point)
			var found_tile = false
			for tile in LevelData.tile_list:
				if tile.position_in_tilemap == map_point:
					found_tile = true
					manipulate_tile(tile)
			if !found_tile:
				make_tile(map_point, target)
	else:
		gun.get_node("Line2D").visible = false
		gun.get_node("RayCast2D").enabled = false

func make_tile(pos, tilemap):
	var tile = Tile.new()
	var cell_exists = false
	for cell in tilemap.get_used_cells(0):
		if pos == cell:
			cell_exists = true
	if cell_exists:
		tile.tile_name = tilemap.get_cell_tile_data(0, pos).get_custom_data("block name")
		tile.tile_id = tilemap.get_cell_source_id(0,pos)
		tile.max_health = tilemap.get_cell_tile_data(0, pos).get_custom_data("health")
		tile.health = tilemap.get_cell_tile_data(0, pos).get_custom_data("health")
		tile.position_in_tilemap = pos
		tile.position_in_atlas = tilemap.get_cell_atlas_coords(0, pos)
		tile.tilemap = tilemap
		LevelData.tile_list.append(tile)
		manipulate_tile(tile)

func manipulate_tile(tile):
	tile.take_damage(10)

func add_to_inventory(item):
	item.queue_free()
