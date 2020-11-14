extends RigidBody2D
class_name GenericMayan

var initial_position := Vector2.ZERO;
var collision_count = 0
var angriness = 0.0 # how mad they are, from 0.0 to 2.0
var furthest_distance_ever = 0.0
var distance_to_initial_position = 0.0

var isGuard := false
signal got_angry

var ACCEPTABLE_DISTANCE = 0 # max distance before mayans get angry
var MAX_DISTANCE = 30
var MAX_ANGRINESS_BEFORE_ITS_TOO_LATE = 1.5
var FRICTION = 0.3
var SPEED = 50

var player

func _ready():
	initial_position = self.position

func _integrate_forces(state):
	_get_distance_to_initial_position(state)
	_friction_force(state)
	_get_angriness(state)
	_turn_color(state)
	
	if angriness < MAX_ANGRINESS_BEFORE_ITS_TOO_LATE:
		_go_back_to_original_position_force(state)
	else:
		_run_after_player(state)

	
func _get_distance_to_initial_position(state):
	distance_to_initial_position = position.distance_to(initial_position)
	if distance_to_initial_position > furthest_distance_ever:
		furthest_distance_ever = distance_to_initial_position
	
func _get_angriness(state):
	var new_angriness = max(0.0, min(2.0, 1.0*(furthest_distance_ever - ACCEPTABLE_DISTANCE) / (MAX_DISTANCE - ACCEPTABLE_DISTANCE)))
	if (angriness < MAX_ANGRINESS_BEFORE_ITS_TOO_LATE) and (new_angriness > MAX_ANGRINESS_BEFORE_ITS_TOO_LATE):
		emit_signal("got_angry")
	angriness = new_angriness

	#if distance_to_initial_position < ACCEPTABLE_DISTANCE*2.0:
	if angriness <MAX_ANGRINESS_BEFORE_ITS_TOO_LATE:
		furthest_distance_ever *= 0.995
		
func _turn_color(state):
	self.modulate.g = 1.0 - min(1.0, angriness)
	self.modulate.b = 1.0 - min(1.0, angriness)
	self.modulate.r = max(0.5, min(1.0, 2.0 - angriness))
	
	
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
	
	
