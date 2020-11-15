extends RigidBody2D
class_name GenericMayan

onready var animation_player = $AnimationPlayer as AnimationPlayer

var initial_position := Vector2.ZERO;
var collision_count = 0
var angriness = 0.0 setget _set_angriness # how mad they are, from 0.0 to 2.0
var furthest_distance_ever = 0.0
var distance_to_initial_position = 0.0

var isGuard := false
signal got_angry

var ACCEPTABLE_DISTANCE = 0 # max distance before mayans get angry
var MAX_DISTANCE = 30
var MAX_ANGRINESS_BEFORE_ITS_TOO_LATE = 1.5
var FRICTION = 0.3
var SPEED = 50
var CALM_DOWN = 0.995 # how fast they calm down wen angry from 1. to 0.
var RUN_ANIMATION = "MayanWalking"
var IDLE_ANIMATION = "MayanIdle"

var player

func _ready():
	initial_position = self.position

	# Initialize randomly delayed animation for each Mayan
	yield(get_tree().create_timer(rand_range(0, 1)), "timeout")
	animation_player.play(IDLE_ANIMATION)

func _integrate_forces(state):
	_get_distance_to_initial_position()
	_friction_force(state)
	_get_angriness()

	
	if angriness < MAX_ANGRINESS_BEFORE_ITS_TOO_LATE:
		_go_back_to_original_position_force(state)
	else:
		_run_after_player(state)
	
	var is_moving = self.linear_velocity.length() > 2

	if is_moving:
		animation_player.play(RUN_ANIMATION)
	else:
		# TODO this breaks the random initial delay
		animation_player.play(IDLE_ANIMATION)

	
func _get_distance_to_initial_position():
	distance_to_initial_position = position.distance_to(initial_position)
	if distance_to_initial_position > furthest_distance_ever:
		furthest_distance_ever = distance_to_initial_position
	
func _get_angriness():
	var new_angriness = max(0.0, min(2.0, 1.0*(furthest_distance_ever - ACCEPTABLE_DISTANCE) / (MAX_DISTANCE - ACCEPTABLE_DISTANCE)))
	
	if new_angriness == angriness:
		return
	
	if (angriness < MAX_ANGRINESS_BEFORE_ITS_TOO_LATE) and (new_angriness > MAX_ANGRINESS_BEFORE_ITS_TOO_LATE):
		emit_signal("got_angry")
	_set_angriness(new_angriness)

	#if distance_to_initial_position < ACCEPTABLE_DISTANCE*2.0:
	if angriness <MAX_ANGRINESS_BEFORE_ITS_TOO_LATE:
		furthest_distance_ever *= CALM_DOWN
		
func _turn_color():
	self.modulate.g = 1.0 - min(0.9, angriness)
	self.modulate.b = 1.0 - min(0.9, angriness)
	self.modulate.r = max(0.9, min(1.0, 2.0 - angriness))
	
	
func _friction_force(state):
	state.apply_central_impulse(-state.linear_velocity * FRICTION)

func _go_back_to_original_position_force(state):
	var direction_towards_initial_position = position.direction_to(initial_position)
	
	if distance_to_initial_position > ACCEPTABLE_DISTANCE/2.0:
		state.apply_central_impulse(direction_towards_initial_position * distance_to_initial_position * min(1.0, angriness))
	else:
		return null

func _get_player_direction() -> Vector2:
	if !player:
		return Vector2.ZERO
	var direction_towards_player = position.direction_to(player.position)
	direction_towards_player = direction_towards_player.normalized()
	return direction_towards_player

func _run_after_player(state):
	var direction_towards_player = _get_player_direction()
	state.apply_central_impulse(direction_towards_player * SPEED)

func _set_angriness(new_angriness):
	angriness = new_angriness
	$Exclamation.update_exclamations(angriness, MAX_ANGRINESS_BEFORE_ITS_TOO_LATE)
	_turn_color()
