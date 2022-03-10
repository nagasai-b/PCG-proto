extends Node2D
onready var player = preload("res://scenes/car.tscn")
onready var chkpt = preload("res://sounds/checkpoint.wav")
onready var mus = preload("res://sounds/skatune.mp3")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var p
var current_checkpoint = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	start_game()

func start_game():
#	Generate the map, create a player, and put them in based on the 
#	start of the map -- screen_points @ 0
	$TileTrack.make_maze()
	$TileTrack.translate_to_world()
	p = player.instance()
	add_child(p)
	p.position = Vector2(32,32)
	$MusicPlayer.bus = "Music"
	$MusicPlayer.stream = mus
	$MusicPlayer.play()
	$SoundPlayer.bus = "Master"

func _process(delta):
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
	
	if $TileTrack.goal.distance_to(p.position) < 30:
		print_debug("Level Finished! ")
		$SoundPlayer.stream = chkpt
		$SoundPlayer.play()
		get_tree().reload_current_scene()

