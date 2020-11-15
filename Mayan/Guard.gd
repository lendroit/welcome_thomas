extends "res://Mayan/GenericMayan.gd"

var Spear = load("res://Mayan/SubElements/Spear.tscn")

var throw_sounds = [
	preload("res://assets/Sounds/throw_01_session.wav"),
	preload("res://assets/Sounds/throw_02_session.wav"),
	preload("res://assets/Sounds/throw_03_session.wav"),
	preload("res://assets/Sounds/throw_04_session.wav"),
	preload("res://assets/Sounds/throw_05_session.wav"),
	preload("res://assets/Sounds/throw_06_session.wav")	
]

onready var throw = $AudioPlayers/Throw

var timer

func _init():
	self.RUN_ANIMATION = "GuardRunning"
	self.IDLE_ANIMATION = "GuardIdle"

	timer = Timer.new()
	add_child(timer)
	timer.autostart = true
	randomize()
	timer.wait_time = 2 + rand_range(-0.5, 0.5)
	timer.connect("timeout", self, "_timeout")


func _timeout():
	if angriness > MAX_ANGRINESS_BEFORE_ITS_TOO_LATE:
		throw_spear()



func _ready():
	isGuard = true
	
	ACCEPTABLE_DISTANCE = 0 # max distance before mayans get angry
	MAX_DISTANCE = 3
	MAX_ANGRINESS_BEFORE_ITS_TOO_LATE = 1.1
	SPEED = 20


func throw_spear():
	var direction_towards_player = _get_player_direction()
	var b = Spear.instance()
	b.position = self.global_position
	b.rotation = direction_towards_player.angle()

	# TODO this should be a signal
	var level_node = get_node("/root/World/Level")
	_play_throw_sound()

	if level_node != null:
	 level_node.add_child(b)
	pass

func _play_throw_sound():
	var random_index = randi()%throw_sounds.size()
	throw.stream = throw_sounds[random_index]
	throw.play()
