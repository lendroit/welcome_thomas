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

var current_level = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	_connect_level()
	replayButton.connect("pressed", self, "_restart_game")

func _connect_level():
	$Level.connect('player_won', self, "_player_won")
	$Level.connect('player_died', self, "_player_died")

func _player_won():
	_next_level()

func _player_died():
	endOfGameLabel.text = 'OHH !'
	endOfGameLabel.visible = true

func _restart_game():
	endOfGameLabel.visible = false
	# TODO hack to make it simpler but it sucks
	current_level -= 1
	_next_level()

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
	
	_connect_level()

func _game_end():
	print("BRAVO")
