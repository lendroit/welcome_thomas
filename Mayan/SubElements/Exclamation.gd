extends Node2D

onready var exclamation_1 = $Exclamation1
onready var exclamation_2 = $Exclamation2
onready var exclamation_3 = $Exclamation3
onready var exclamations = [exclamation_1, exclamation_2, exclamation_3]

var continuous_exclamation_level = 0
var has_reached_max = false

func _ready():
	for exclamation in exclamations:
		exclamation.visible = false

func update_exclamations(new_continuous_exclamation_level, max_level):
	# We will never check the exclamations mark again
	# after we have reached the max once, because there
	# is a disappearance animation triggered
	if has_reached_max:
		return

	if max_level == 0:
		push_error("max_level should not be null")

	continuous_exclamation_level = new_continuous_exclamation_level
	
	# Map the continuous exclamation level to a discrete exclamation level
	# so that we can iterate on excalamation nodes
	var lerped = lerp(0, exclamations.size(), continuous_exclamation_level / max_level)
	var level = floor(min(lerped, exclamations.size()))

	for index in range(0, exclamations.size()):
		var exclamation = exclamations[index]
		exclamation.visible = index < level
	
	if level == exclamations.size():
		has_reached_max = true
		yield(get_tree().create_timer(1), "timeout")
		self.visible = false

