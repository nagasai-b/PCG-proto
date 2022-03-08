extends TileMap


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var egg = 1
var width = 64
var height = 39
var grid = []
var generated = false
var rng = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	for i in range(width):
		grid.append([])
		for j in range(height):
			grid[i].append(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if generated==false:
		create_map()
		generated = true
	


func create_map():
	var temp_points = []
	for i in range(5):
		var x = rng.randf_range(0, width)
		var y = rng.randf_range(0, height)
		grid[x][y] = 1
		temp_points.append([x,y])
	
	var center = [0, 0]
	
	for i in temp_points:
		center[0] += i[0]
		center[1] += i[1]
	
	center[0] = floor(center[0]/5)
	center[1] =	floor(center[1]/5)
	
	grid[center[0]][center[1]] = 1
	
	for i in range(width):
		for j in range(height):
			set_cell(i,j,grid[i][j]);
	pass
	
