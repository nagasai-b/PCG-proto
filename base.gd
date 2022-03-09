extends Node2D
onready var player = preload("res://scenes/car.tscn")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	start_game()

func start_game():
#	Generate the map, create a player, and put them in based on the 
#	start of the map -- screen_points @ 0
	$TileMap.create_map()
	var p = player.instance()
	add_child(p)
	p.position = $TileMap.screen_points[0]

func _process(delta):
	pass
