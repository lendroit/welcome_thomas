extends RigidBody2D

var initial_position := Vector2.ZERO;
var collision_count = 0
var angriness = 0.0
var furthest_distance_ever = 0.0

const ACCEPTABLE_DISTANCE = 10 # max distance before mayans get angry
const MAX_DISTANCE = 50
const FRICTION = 0.3
const SPEED = 0.5

func _ready():
	initial_position = self.position

func _integrate_forces(state):
	_friction_force(state)
	_go_back_to_original_position_force(state)
	
func _friction_force(state):
	state.apply_central_impulse(-state.linear_velocity * FRICTION)

func _go_back_to_original_position_force(state):
	var direction_towards_initial_position = position.direction_to(initial_position)
	var distance_to_initial_position = position.distance_to(initial_position)
	
	if distance_to_initial_position > furthest_distance_ever:
		furthest_distance_ever = distance_to_initial_position
	
	#if distance_to_initial_position < ACCEPTABLE_DISTANCE:
	#	angriness = 0.0
	#else:
		#angriness = max(0.0, min(1.0, (furthest_distance_ever*1.0 - ACCEPTABLE_DISTANCE*1.0) / (MAX_DISTANCE*1.0 - ACCEPTABLE_DISTANCE*1.0)))
	angriness = max(0.0, min(1.0, 1.0*(furthest_distance_ever - ACCEPTABLE_DISTANCE) / (MAX_DISTANCE - ACCEPTABLE_DISTANCE)))
	self.modulate.g = 1.0 - angriness
	self.modulate.b = 1.0 - angriness
	
	
	if distance_to_initial_position > ACCEPTABLE_DISTANCE:
		state.apply_central_impulse(direction_towards_initial_position * distance_to_initial_position * SPEED)

		
		
