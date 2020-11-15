extends Node2D

var Outro = preload("res://Intro/Outro.tscn")

const STARTING_LEVEL = 0
const LEVEL_PATHS = [
	"res://Levels/LevelA.tscn",
	"res://Levels/LevelB.tscn",
	"res://Levels/LevelC.tscn",
	"res://Levels/LevelD.tscn",
	"res://Levels/LevelE.tscn",
]

onready var player_won_interface = $Gui/PlayerWonInterface
onready var replay_button = $Gui/PlayerWonInterface/ReplayButton
onready var next_level_button = $Gui/PlayerWonInterface/NextLevelButton
onready var player_died_interface = $Gui/PlayerDiedInterface
onready var replay_button_2 = $Gui/PlayerDiedInterface/ReplayButton

var victory_sounds = [
	preload("res://assets/Sounds/victory_session.wav")
]

var theme_sound = preload("res://assets/Sounds/r1_session.wav")

onready var victory = $AudioPlayers/Victory
onready var theme = $AudioPlayers/Theme

var current_level = STARTING_LEVEL

# Called when the node enters the scene tree for the first time.
func _ready():
	_play_theme_sound()
	print(("world is ready"))
	_deferred_instanciate_level(LEVEL_PATHS[current_level])
	next_level_button.connect("pressed", self, "_next_level")
	replay_button.connect("pressed", self, "_restart_level")
	replay_button_2.connect("pressed", self, "_restart_level")

func _connect_level():
	$Level.connect('player_won', self, "_player_won")
	$Level.connect('player_died', self, "_player_died")

func _player_won():
	_play_victory_sound()
	var current_level_is_last_level = (current_level == LEVEL_PATHS.size() - 1)
	if current_level_is_last_level:
		_game_end()
		return
	self.remove_child($Level)
	player_won_interface.visible = true

func _player_died():
	player_died_interface.visible = true

func _restart_level():
	player_won_interface.visible = false
	player_died_interface.visible = false
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
	player_won_interface.visible = false
	current_level += 1

	_deferred_instanciate_level(LEVEL_PATHS[current_level])

func _game_end():
	get_tree().change_scene_to(Outro)

func _play_victory_sound():
	var random_index = randi()%victory_sounds.size()
	victory.stream = victory_sounds[random_index]
	victory.play()

func _play_theme_sound():
	theme.stream = theme_sound
	theme.play()
