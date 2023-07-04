class_name Snake
extends Node2D

const BODY_SEGMENT_SIZE = 16

enum CollisionDirection{
	TOP,
	BOTTOM,
	LEFT,
	RIGHT
}

@export var walls: Walls
var wall_dict

var body_parts = []
var body_texture = preload("res://assets/snake-sprite.png")
@onready var snake_parts: Node = $snake_parts
@onready var timer = $Timer

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
		move_to_position(position_after_wall_collision)
	
	move_to_position(new_head_position)
	
	
func move_to_position(new_position):
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
	elif (wall_collision == CollisionDirection.LEFT or wall_collision == CollisionDirection.RIGHT) and new_head_position.x > 0:
		move_direction = Vector2.UP
	elif (wall_collision == CollisionDirection.TOP or wall_collision == CollisionDirection.BOTTOM) and new_head_position.y <= 0:
		move_direction = Vector2.RIGHT
	elif (wall_collision == CollisionDirection.TOP or wall_collision == CollisionDirection.BOTTOM) and new_head_position.y > 0:
		move_direction = Vector2.LEFT
		
	return body_parts[0].position + move_direction * BODY_SEGMENT_SIZE
