extends KinematicBody2D

export (int) var speed = 800
export (int) var push = 100
const ACCELERATION = 5000
const MAX_SPEED = 300
const FRICTION = 10000

var velocity = Vector2.ZERO
var item_held = null
var is_dead = false

onready var reachableObjectsArea = $ReachableObjectsArea
onready var animation_player = $AnimationPlayer

signal player_won
signal player_died

func _pick_item(item: Node2D):
	item_held = item
	item.visible = false

func _drop_item():
	item_held.position = position
	item_held.visible = true
	item_held = null

func has_entered_drop_area():
	if(item_held):
		_drop_item()
		emit_signal("player_won")

func has_been_hit(body):
	_die()

func _die():
	self.rotation += PI/4
	if !is_dead:
		is_dead = true
		emit_signal("player_died")

func _input(event):
	if is_dead:
		return
	if event.is_action_pressed("ui_accept"):
		if !item_held:
			var reachable_item = reachableObjectsArea.get_item_if_any()
			if reachable_item:
				_pick_item(reachable_item)
		else:
			_drop_item()

func _physics_process(delta):
	if is_dead:
		return

	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")


	if input_vector.length() > 1:
		input_vector = input_vector.normalized()

	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
		animation_player.play("BearWalks")
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		animation_player.play("BearIdle")
	
	velocity = move_and_slide(velocity, Vector2.ZERO, false, 4, PI / 4, false)
	
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.get_collision_layer_bit(2):
			collision.collider.apply_central_impulse(-collision.normal * push)
			pass
