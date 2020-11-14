extends Area2D

var speed = 750


func _physics_process(delta):
	print("I EXIST!!!")
	print(position)
	position += Vector2.RIGHT * speed * delta

func _on_Bullet_body_entered(body):
	if body.is_in_group("mobs"):
		print("YOLO")
	print("YOLO")
