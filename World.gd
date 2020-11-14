extends YSort

onready var player = $Player
onready var mayans = $Mayans
onready var dropOffrandeArea = $DropOffrandeArea
onready var playerWonLabel = $Gui/PlayerWonLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	dropOffrandeArea.connect('body_entered', self, "_body_entered_drop_zone")
	player.connect('player_won', self, "_player_won")
	for child in mayans.get_children():
		var maya = child as GenericMayan
		maya.player = player

func _body_entered_drop_zone(body):
	if(body == player):
		print("This is the player")
		player.has_entered_drop_area()

func _player_won():
	playerWonLabel.visible = true
	print("player won")
