extends Area2D

var nearby_bodies = []

func _ready():
	connect("body_entered", self, "body_entered")
	connect("body_exited", self, "body_exited")


func body_entered(body):
	nearby_bodies.append(body)

func body_exited(body):
	nearby_bodies.erase(body)
	
func get_item_if_any():
	if(nearby_bodies.size() == 0):
		return null
	return nearby_bodies[0]
