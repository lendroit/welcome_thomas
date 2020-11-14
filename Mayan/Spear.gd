extends Area2D

var speed = 750

var Player = load("res://Player/Player.tscn")

func _physics_process(delta):
	position += transform.x * speed * delta

func _on_Spear_body_entered(body):
	if body.has_method("has_been_hit"):
		body.has_been_hit(self)
	pass # Replace with function body.
