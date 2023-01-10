extends CharacterBody2D

var stack = 1
var item = 0
var frames_alive = 0

func _physics_process(delta):
	frames_alive += 1
	velocity.y += LevelData.gravity * delta
	move_and_slide()

func _on_area_2d_area_entered(other_item_area):
	print(other_item_area)
	if other_item_area.is_in_group("item"):
		var other_item = other_item_area.get_parent()
		if frames_alive < other_item.frames_alive:
			delete_other_stack(other_item)
		elif other_item.frames_alive < frames_alive:
			delete_this_stack(other_item)
		elif frames_alive == other_item.frames_alive:
			var stack_to_be_deleted = randi_range(0,1)
			if stack_to_be_deleted == 0:
				delete_other_stack(other_item)
			else:
				delete_this_stack(other_item)

func delete_other_stack(other_item):
	stack += other_item.stack
	other_item.queue_free()
	
func delete_this_stack(other_item):
	other_item.stack += stack
	queue_free()
