extends Node2D

const LEVEL_PATHS = [
	"res://Levels/LevelA.tscn",
	"res://Levels/LevelB.tscn",
]

onready var player = $Level/Elements/Player
onready var mayans = $Level/Elements/Mayans
onready var dropOffrandeArea = $Level/DropOffrandeArea
onready var endOfGameLabel = $Gui/EndOfGameLabel
onready var replayButton = $Gui/EndOfGameLabel/Button

var number_of_angry_mayans = 0
var number_of_guards = 0
var current_level = 0

func _treasure_got_picked():
	for child in mayans.get_children():
		if (child.isGuard) and (child.angriness < child.MAX_ANGRINESS_BEFORE_ITS_TOO_LATE):
			child.angriness = 2.0
			child.furthest_distance_ever = 50000
			break

func _on_new_angry_mayan():
	number_of_angry_mayans += 1
	if number_of_angry_mayans%5 == 0:
		for child in mayans.get_children():
			if (child.isGuard) and (child.angriness < child.MAX_ANGRINESS_BEFORE_ITS_TOO_LATE):
				child.angriness = 2.0
				child.furthest_distance_ever = 50000
				break

# Called when the node enters the scene tree for the first time.
func _ready():
	dropOffrandeArea.connect('body_entered', self, "_body_entered_drop_zone")
	player.connect("player_picked", self, "_treasure_got_picked")
	player.connect('player_won', self, "_player_won")
	player.connect('player_died', self, "_player_died")
	replayButton.connect("pressed", self, "_restart_game")
	for child in mayans.get_children():
		var maya = child as GenericMayan
		maya.connect("got_angry", self, "_on_new_angry_mayan")
		maya.player = player
	for child in mayans.get_children():
		if child.isGuard:
			number_of_guards += 1
	
func _body_entered_drop_zone(body):
	if(body == player):
		player.has_entered_drop_area()

func _player_won():
	_next_level()

func _player_died():
	endOfGameLabel.text = 'OHH !'
	endOfGameLabel.visible = true

func _restart_game():
	get_tree().reload_current_scene()

func _next_level():
	var level = $Level
	current_level += 1

	if current_level >= LEVEL_PATHS.size():
		_game_end()
		return
	
	var new_level_path = LEVEL_PATHS[current_level]
	var new_level = load(new_level_path)
	
	self.remove_child(level)
	add_child(new_level.instance())

func _game_end():
	print("YOU WIN")
	pass
