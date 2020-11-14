extends KinematicBody2D

export (int) var speed = 800
export (int) var push = 100

var velocity = Vector2.ZERO
var item_held = null

onready var reachableObjectsArea = $ReachableObjectsArea

func get_input():
	velocity.x = 0
	velocity.y = 0
	if Input.is_action_just_pressed("ui_accept"):
		if !item_held:
			var reachable_item = reachableObjectsArea.get_item_if_any()
			if reachable_item:
				_pick_item(reachable_item)
		else:
			_drop_item()

	if Input.is_action_pressed("ui_right"):
		velocity.x += speed
	if Input.is_action_pressed("ui_left"):
		velocity.x -= speed
	if Input.is_action_pressed("ui_up"):
		velocity.y -= speed
	if Input.is_action_pressed("ui_down"):
		velocity.y += speed

func _pick_item(item: Node2D):
	item_held = item
	item.visible = false

func _drop_item():
	item_held.position = position
	item_held.visible = true
	item_held = null



func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity, Vector2.ZERO, false, 4, PI/4, false)
	
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.get_collision_layer_bit(2):
			collision.collider.apply_central_impulse(-collision.normal * push)
			pass
