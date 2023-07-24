extends Node2D

@onready var title_label = $title_container/title
@onready var start_button = $play_control/start_button
@onready var quit_button = $play_control/quit_button
@onready var sfx_1 = $start_sfx
@onready var sfx_2 = $start_sfx2
@onready var sfx_3 = $start_sfx3

func _on_start_button_pressed():
	sfx_1.play()

func _on_start_sfx_finished():
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_settings_button_pressed():
	sfx_2.play()

func _on_start_sfx_2_finished():
	get_tree().change_scene_to_file("res://scenes/settings_menu.tscn")

func _on_quit_button_pressed():
	sfx_3.play()

func _on_start_sfx_3_finished():
	get_tree().quit()
