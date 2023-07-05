extends CanvasLayer

@onready var button_container: BoxContainer

@onready var restart_button = $BoxContainer/restart
@onready var quit_button = $BoxContainer/quit
@onready var points_label = $points_label
@onready var gameover = $gameover_label

@onready var snake: Snake = $"../snake"

func _ready():
	snake.on_points_scored.connect(on_points_scored)
	snake.on_game_over.connect(on_game_over)
	button_container = get_node("BoxContainer")
	quit_button.pressed.connect(_on_quit_pressed)
	
func on_game_over():
	button_container.visible = true
	gameover.visible = true
	
func on_points_scored(points: int):
	points_label.text = "Points: %d" % points

func _on_quit_pressed():
	get_tree().quit()

func _on_restart_pressed():
	get_tree().reload_current_scene()
