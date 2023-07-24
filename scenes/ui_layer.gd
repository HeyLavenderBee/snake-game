extends CanvasLayer

@onready var button_container: BoxContainer

@onready var restart_button = $BoxContainer/restart
@onready var quit_button = $BoxContainer/quit
@onready var points_label = $points_label
@onready var gameover = $gameover_label
@onready var main_menu = $BoxContainer/main_menu
@onready var sfx_1 = $sfx_1
@onready var sfx_2 = $sfx_2
@onready var sfx_3 = $sfx_3
var volume = global.volume

@onready var snake: Snake = $"../snake"

func _ready():
	gameover.hide()
	snake.on_points_scored.connect(on_points_scored)
	snake.on_game_over.connect(on_game_over)
	button_container = get_node("BoxContainer")
	quit_button.pressed.connect(_on_quit_pressed)

func _physics_process(delta):
	global.volume = volume
	print(volume)
	sfx_1.set_volume_db(volume)
	
func on_game_over():
	button_container.show()
	gameover.show()

func on_points_scored(points: int):
	points_label.text = "Points: %d" % points

func _on_quit_pressed():
	sfx_3.play()

func _on_restart_pressed():
	sfx_2.play()

func _on_main_menu_pressed():
	sfx_1.play()

func _on_change_vol(volume:int):
	global.volume = volume
	print(volume)
	sfx_1.set_volume_db(volume)

func _on_sfx_1_finished():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_sfx_2_finished():
	get_tree().reload_current_scene()

func _on_sfx_3_finished():
	get_tree().quit()
