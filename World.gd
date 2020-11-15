extends Node2D

const STARTING_LEVEL = 0
const LEVEL_PATHS = [
	"res://Levels/LevelA.tscn",
	"res://Levels/LevelB.tscn",
	"res://Levels/LevelC.tscn",
	"res://Levels/LevelD.tscn",
	"res://Levels/LevelE.tscn",
]

onready var endOfGameLabel = $Gui/EndOfGameLabel
onready var replayButton = $Gui/EndOfGameLabel/Button

var current_level = STARTING_LEVEL

# Called when the node enters the scene tree for the first time.
func _ready():
	_deferred_instanciate_level(LEVEL_PATHS[current_level])
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
	_deferred_instanciate_level(LEVEL_PATHS[current_level])

# Necessary to fix an error when this is called from a signal
func _deferred_instanciate_level(level_path: String):
	call_deferred("_instanciate_level", level_path)

func _instanciate_level(level_path: String):
	var new_level = load(level_path)
	
	self.remove_child($Level)
	add_child(new_level.instance())
	_connect_level()

func _next_level():
	current_level += 1

	if current_level >= LEVEL_PATHS.size():
		_game_end()
		return
	
	_deferred_instanciate_level(LEVEL_PATHS[current_level])

func _game_end():
	print("BRAVO")
