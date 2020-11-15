extends Control



onready var end_of_game_music = $EndOfGameMusic

func _ready():
	end_of_game_music.play()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		var World = load("res://World.tscn")
		get_tree().change_scene_to(World)
