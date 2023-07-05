extends Node
class_name Food_spawner

@export var walls: Walls
@export var food_scene: PackedScene

var food_position: Vector2
var food: Sprite2D

const BODY_SEGMENT_SIZE = 16

func _ready():
	spawn_food()
	
func spawn_food():
	food = food_scene.instantiate()
	var x_pos = round(randi_range(walls.top_left_corner.x + BODY_SEGMENT_SIZE, walls.bottom_right_corner.x - BODY_SEGMENT_SIZE)/BODY_SEGMENT_SIZE)*BODY_SEGMENT_SIZE
	var y_pos = round(randi_range(walls.top_left_corner.y + BODY_SEGMENT_SIZE, walls.bottom_right_corner.y - BODY_SEGMENT_SIZE)/BODY_SEGMENT_SIZE)*BODY_SEGMENT_SIZE
	add_child(food)
	food_position = Vector2(x_pos, y_pos)
	food.position = food_position
	print(food_position)

func destroy_food():
	if food != null:
		food.queue_free()
