extends TileMap


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var astar = AStar2D.new()
var width = 32
var height = 19
var grid = {}
var generated = false
var rng = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	astar.reserve_space(width*height)
	var pointID = 1
	for i in range(width):
		for j in range(height):
			set_cell(i, j, 0)
			grid[Vector2(i,j)] = pointID
			astar.add_point(pointID, Vector2(i,j), 1.0)
			pointID+=1 
	var neighbors = [Vector2(0,-1),Vector2(0,1),Vector2(1,0), Vector2(-1, 0)]
	
	for pt in grid.keys():
		for n in neighbors:
			if grid.has(pt+n):
				astar.connect_points(grid[pt], grid[pt+n], false)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if generated==false:
		create_map()
		generated = true
	


func create_map():
	var temp_points = PoolVector2Array()
	for i in range(5):
		var x = floor(rng.randf_range(0, width))
		var y = floor(rng.randf_range(0, height))
		set_cell(x,y,1)
		temp_points.append(Vector2(x,y))
	for p in range(1,5):
		var p1 = grid[temp_points[p-1]]
		var p2 = grid[temp_points[p]]
		var path = astar.get_point_path(p1,p2)
		for line in path:
			set_cell(line.x,line.y,1)
		pass
	pass
