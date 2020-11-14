extends YSort


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var player = $Player
onready var mayans = $Mayans


# Called when the node enters the scene tree for the first time.
func _ready():
	for child in mayans.get_children():
		var maya = child as Mayan
		maya.player = player

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
