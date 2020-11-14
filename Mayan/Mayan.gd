extends RigidBody2D

var initial_position := Vector2.ZERO;

const FRICTION = 0.3
const SPEED = 0.5

func _ready():
	initial_position = self.position

func _integrate_forces(state):
	state.apply_central_impulse(-state.linear_velocity * FRICTION)

	var direction_towards_initial_position = position.direction_to(initial_position)
	var distance_to_initial_position = position.distance_to(initial_position)
	state.apply_central_impulse(direction_towards_initial_position * distance_to_initial_position * SPEED)
