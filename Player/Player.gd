extends KinematicBody2D

export (int) var speed = 800

var velocity = Vector2.ZERO

onready var reachableObjectsArea = $ReachableObjectsArea

func get_input():
	velocity.x = 0
	velocity.y = 0
	if Input.is_action_just_pressed("ui_accept"):
		var picked_body = reachableObjectsArea.pick_body()
		print(picked_body)
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
