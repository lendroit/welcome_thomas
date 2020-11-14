extends RigidBody2D

var initial_position := Vector2.ZERO;

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
	
	if distance_to_initial_position > 30:
		state.apply_central_impulse(direction_towards_initial_position * distance_to_initial_position * SPEED)
