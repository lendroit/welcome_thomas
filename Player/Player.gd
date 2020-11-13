extends KinematicBody2D

export (int) var speed = 800

var velocity = Vector2.ZERO
var holding_item = false

onready var reachableObjectsArea = $ReachableObjectsArea

func get_input():
	velocity.x = 0
	velocity.y = 0
	if Input.is_action_just_pressed("ui_accept") && !holding_item:
		var reachable_item = reachableObjectsArea.get_item_if_any()
		if reachable_item:
			_pick_object(reachable_item)

	if Input.is_action_pressed("ui_right"):
		velocity.x += speed
	if Input.is_action_pressed("ui_left"):
		velocity.x -= speed
	if Input.is_action_pressed("ui_up"):
		velocity.y -= speed
	if Input.is_action_pressed("ui_down"):
		velocity.y += speed

func _pick_object(item: Node2D):
	holding_item = true
	item.visible = false
	print(item)

func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity)
