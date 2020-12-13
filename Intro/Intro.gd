extends Control

var World = preload("res://World.tscn")

func _input(event):
	if event.is_action_pressed("ui_accept") || event is InputEventMouseButton:
		get_tree().change_scene_to(World)
