class_name Walls
extends Node

var wall_dict = {}

var top_left_corner: Vector2
var bottom_right_corner: Vector2

func _ready():
	var walls = get_tree().get_nodes_in_group("walls") as Array[Node2D]
	for wall in walls:
		if wall.position.x < 0:
			wall_dict["left"] = wall
		elif wall.position.x > 0:
			wall_dict["right"] = wall
		elif wall.position.y < 0:
			wall_dict["top"] = wall
		elif wall.position.y > 0:
			wall_dict["bottom"] = wall
			
	top_left_corner = Vector2(wall_dict["left"].position.x, wall_dict["top"].position.y)
	bottom_right_corner = Vector2(wall_dict["right"].position.x, wall_dict["bottom"].position.y)
	
