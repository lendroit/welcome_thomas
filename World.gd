extends YSort

onready var player = $Player
onready var mayans = $Mayans
onready var dropOffrandeArea = $DropOffrandeArea


# Called when the node enters the scene tree for the first time.
func _ready():
	dropOffrandeArea.connect('body_entered', self, "_body_entered_drop_zone")
	for child in mayans.get_children():
		var maya = child as GenericMayan
		maya.player = player

func _body_entered_drop_zone(body):
	print('Entered')
	print(body)
	if(body == player):
		print("This is the player")
