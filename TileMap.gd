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
var start_point:Vector2
var point_path = []
# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	astar.reserve_space(width*height)
	var pointID = 1
	for i in range(width):
		for j in range(height):
			set_cell(i, j, 1)
			grid[Vector2(i,j)] = pointID
			astar.add_point(pointID, Vector2(i,j), 1.0)
			pointID+=1 
	var neighbors = [Vector2(0,-1),Vector2(0,1),Vector2(1,0), Vector2(-1, 0)]
	
	for pt in grid.keys():
		for n in neighbors:
			if grid.has(pt+n):
				astar.connect_points(grid[pt], grid[pt+n], false)
	

func create_map():
	var temp_points = PoolVector2Array()
	var num_points = 5
	var state_count = 0
	var lower_boundx:int
	var upper_boundx:int
	var lower_boundy:int
	var upper_boundy:int
	for i in range(num_points):
		match state_count:
			0:
				lower_boundx = 1
				upper_boundx = floor(width/2)
				lower_boundy = 1
				upper_boundy = floor(height/2)
			1:
				lower_boundx = floor(width/2)
				upper_boundx = width-1
				lower_boundy = 1
				upper_boundy = floor(height/2)
			2:
				lower_boundx = 1
				upper_boundx = floor(width/2)
				lower_boundy = floor(height/2)
				upper_boundy = height-1
			3:
				lower_boundx = floor(width/2)
				upper_boundx = width-1
				lower_boundy = floor(height/2)
				upper_boundy = height-1
		var x = floor(rng.randf_range(lower_boundx, upper_boundx))
		var y = floor(rng.randf_range(lower_boundy, upper_boundy))
		set_cell(x,y,2+i)
		temp_points.append(Vector2(x,y))
		state_count = (state_count+1) % 4
	point_path.append(temp_points[0])
	temp_points.remove(0)
	while temp_points.size()>0:
		var min_dist = INF
		var to_remove = -1
		var next_closest:Vector2
		var path_head = point_path.back()
		for i in range(temp_points.size()):
			var dist = path_head.distance_to(temp_points[i])
			if dist < min_dist:
				min_dist = dist
				next_closest = temp_points[i]
				to_remove = i
		point_path.append(next_closest)
		temp_points.remove(to_remove)
		
	for i in range(1,5):
		var pt1 = grid[point_path[i-1]]
		var pt2 = grid[point_path[i]]
		var path = astar.get_point_path(pt1, pt2)
		for l in range(1,path.size()-1):
			var cellcheck = get_cell(path[l].x, path[l].y)
			if cellcheck==1:
				set_cell(path[l].x, path[l].y, 0)
	var final_path = astar.get_point_path(grid[point_path[4]], grid[point_path[0]])
	for l in range(1,final_path.size()-1):
		var cellcheck = get_cell(final_path[l].x, final_path[l].y)
		if cellcheck==1:
			set_cell(final_path[l].x, final_path[l].y, 0)
	start_point = map_to_world(point_path[0], false) + cell_size / 2
