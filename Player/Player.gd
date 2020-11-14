extends KinematicBody2D

export (int) var speed = 800
export (int) var push = 100
const ACCELERATION = 500
const MAX_SPEED = 1000
const FRICTION = 1000

var velocity = Vector2.ZERO
var item_held = null

onready var reachableObjectsArea = $ReachableObjectsArea

func get_input():
	if Input.is_action_just_pressed("ui_accept"):
		if !item_held:
			var reachable_item = reachableObjectsArea.get_item_if_any()
			if reachable_item:
				_pick_item(reachable_item)
		else:
			_drop_item()


	velocity = move_and_slide(velocity)

func _pick_item(item: Node2D):
	item_held = item
	item.visible = false

func _drop_item():
	item_held.position = position
	item_held.visible = true
	item_held = null



func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")


	if input_vector.length() > 1:
		input_vector = input_vector.normalized()

	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	velocity = move_and_slide(velocity)
	
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.get_collision_layer_bit(2):
			collision.collider.apply_central_impulse(-collision.normal * push)
			pass
