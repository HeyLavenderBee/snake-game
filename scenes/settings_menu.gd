extends Node2D

signal _on_vol_changed(volume:int)

@onready var local_vol = $sfx_1.volume_db

var color = 0

var change_scene: bool = false

@onready var back_button = $back_button
@onready var minus_vol = $minus_vol

func _on_back_button_pressed():
	$sfx_1.play()
	change_scene = true

func _on_sfx_1_finished():
	if change_scene == true:
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_minus_vol_pressed():
	global.volume -= 2
	local_vol -= 2
	$sfx_1.set_volume_db(local_vol)
	print(local_vol)
	_on_vol_changed.emit(local_vol)
	change_scene = false
	$sfx_1.play()

func _on_plus_vol_pressed():
	global.volume += 2
	local_vol += 2
	$sfx_1.set_volume_db(local_vol)
	print(local_vol)
	_on_vol_changed.emit(local_vol)
	change_scene = false
	$sfx_1.play()


func _on_bg_color_button_pressed():
	color += 1
	color = clamp(color, 1, 6)
	for i in range(6):
		if color == 1 or color == 4:
			RenderingServer.set_default_clear_color(Color8(37,39,73)) #purple
		elif color == 2 or color == 5:
			RenderingServer.set_default_clear_color(Color8(13,20,73)) #blue
		elif color == 3 or color == 6:
			RenderingServer.set_default_clear_color(Color8(73,20,12)) #red

