extends KinematicBody2D

export (int) var speed = 1200

var velocity = Vector2.ZERO

func get_input():
	velocity.x = 0
	velocity.y = 0
	if Input.is_action_pressed("ui_right"):
		velocity.x += speed
	if Input.is_action_pressed("ui_left"):
		velocity.x -= speed
	if Input.is_action_pressed("ui_up"):
		velocity.y -= speed
	if Input.is_action_pressed("ui_down"):
		velocity.y += speed

func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity)
