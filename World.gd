extends YSort

onready var player = $Player
onready var mayans = $Mayans
onready var dropOffrandeArea = $DropOffrandeArea
onready var playerWonLabel = $Gui/PlayerWonLabel
onready var replayButton = $Gui/PlayerWonLabel/Button

var number_of_angry_mayans = 0

func _on_new_angry_mayan():
	number_of_angry_mayans += 1
	print(number_of_angry_mayans)

# Called when the node enters the scene tree for the first time.
func _ready():
	dropOffrandeArea.connect('body_entered', self, "_body_entered_drop_zone")
	player.connect('player_won', self, "_player_won")
	replayButton.connect("pressed", self, "_restart_game")
	for child in mayans.get_children():
		var maya = child as GenericMayan
		maya.connect("got_angry", self, "_on_new_angry_mayan")
		maya.player = player

func _body_entered_drop_zone(body):
	if(body == player):
		print("This is the player")
		player.has_entered_drop_area()

func _player_won():
	playerWonLabel.visible = true
	print("player won")

func _restart_game():
	get_tree().reload_current_scene()
