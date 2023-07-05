class_name Snake
extends Node2D

const BODY_SEGMENT_SIZE = 16

enum CollisionDirection{
	TOP,
	BOTTOM,
	LEFT,
	RIGHT
}

signal on_points_scored(points: int)
signal on_game_over

var points = 0

@export var walls: Walls
var wall_dict

var body_parts = []
var body_texture = preload("res://assets/snake-sprite.png")
@onready var snake_parts: Node = $snake_parts
@onready var timer = $Timer

var food_spawner: Food_spawner

var move_direction = Vector2.ZERO

func _ready():
	var head = Sprite2D.new()
	head.position = Vector2(0,0)
	head.scale = Vector2(1,1)
	head.texture = body_texture
	snake_parts.add_child(head)
	body_parts.append(head)	
	timer.timeout.connect(on_timeout)
	wall_dict = walls.wall_dict
	food_spawner = get_tree().get_first_node_in_group("food_spawner") as Food_spawner
	print(food_spawner)

func _input(event):
	if (event.is_action_pressed("ui_right") || event.is_action_pressed("right")) && move_direction.x != -1:
		move_direction = Vector2.RIGHT
	elif (event.is_action_pressed("ui_left") or event.is_action_pressed("left")) and move_direction.x != 1:
		move_direction = Vector2.LEFT
	elif (event.is_action_pressed("ui_up") or event.is_action_pressed("up")) and move_direction.y != 1:
		move_direction = Vector2.UP
	elif (event.is_action_pressed("ui_down") or event.is_action_pressed("down")) and move_direction.y != -1:
		move_direction = Vector2.DOWN
	
func on_timeout():
	var new_head_position = position + move_direction * BODY_SEGMENT_SIZE
	var wall_collision = check_wall_collision(new_head_position)
	if wall_collision == null:
		move_to_position(new_head_position)
	else:
		var position_after_wall_collision = get_position_after_wall_collision(wall_collision, new_head_position)
		new_head_position = position_after_wall_collision
		move_to_position(position_after_wall_collision)

	if new_head_position == food_spawner.food_position:
		points += 1
		on_points_scored.emit(points)
		food_spawner.destroy_food()
		food_spawner.spawn_food()
		add_body_part()
		
	var snake_collision = check_snake_collision(new_head_position)
	if snake_collision:
		timer.stop()
		on_game_over.emit()
	
func move_to_position(new_position):
	if body_parts.size() > 1:
		var last_element = body_parts.pop_back()
		last_element.position = body_parts[0].position
		body_parts.insert(1, last_element)
		
	position = new_position
	body_parts[0].position = new_position


func check_wall_collision(new_head_position: Vector2):
	if new_head_position.x ==  wall_dict["left"].position.x and move_direction == Vector2.LEFT:
		return CollisionDirection.LEFT
	elif new_head_position.x ==  wall_dict["right"].position.x and move_direction == Vector2.RIGHT:
		return CollisionDirection.RIGHT
	elif new_head_position.y ==  wall_dict["top"].position.y and move_direction == Vector2.UP:
		return CollisionDirection.TOP
	if new_head_position.y ==  wall_dict["bottom"].position.y and move_direction == Vector2.DOWN:
		return CollisionDirection.BOTTOM

func get_position_after_wall_collision(wall_collision: CollisionDirection, new_head_position: Vector2):
	if (wall_collision == CollisionDirection.LEFT or wall_collision == CollisionDirection.RIGHT) and new_head_position.y <= 0:
		move_direction = Vector2.DOWN
	elif (wall_collision == CollisionDirection.LEFT or wall_collision == CollisionDirection.RIGHT) and new_head_position.y > 0:
		move_direction = Vector2.UP
	elif (wall_collision == CollisionDirection.TOP or wall_collision == CollisionDirection.BOTTOM) and new_head_position.x <= 0:
		move_direction = Vector2.RIGHT
	elif (wall_collision == CollisionDirection.TOP or wall_collision == CollisionDirection.BOTTOM) and new_head_position.x > 0:
		move_direction = Vector2.LEFT
		
	return body_parts[0].position + move_direction * BODY_SEGMENT_SIZE

func add_body_part():
	var new_part = Sprite2D.new()
	new_part.texture = body_texture
	new_part.scale = Vector2(.9,.9)
	snake_parts.add_child(new_part)
	new_part.position = body_parts[-1].position - move_direction * BODY_SEGMENT_SIZE
	body_parts.append(new_part)
			
func check_snake_collision(new_head_position):
	var body_parts_not_head = body_parts.slice(1, body_parts.size())
	if body_parts_not_head.filter(func (part): return part.position == position):
		return true
	return false
