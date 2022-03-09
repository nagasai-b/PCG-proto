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
var point_path = []
var screen_points = []
# Called when the node enters the scene tree for the first time.
func _ready():
#	First, initialize our randomizer and our A* component for pathfinding
#	then we initialize the grid by adding it all to the A* and connecting 
#	them by horizontal and vertical. grid stores an (x,y):pointID pair for later
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
#	The meat of the code. We generate 5 random points (this could be changed 
#	but we only made 5 sprite markers) in a quadrant based on state_count. 
#	this makes it so we end up with some kind of circle shape, at the very least.
#	We then paint these points as default black road (for now) and store them in
#	their generation order
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
		set_cell(x,y,1)
		temp_points.append(Vector2(x,y))
		state_count = (state_count+1) % 4
#	Down here we just reorder them into a more logical path 
#	based on distance from the starting node and store it in point_path
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

#	Here, we let astar do the work of connecting 2 points in the path.
#	this generates an array of vectors which tells us how to reach the 
#	other point. From there, we simply paint our way. Note that we add 
#	buffers to either the up/down or left/right of a node, depending on 
#	what its neighbors are. This smoothens the track a little bit!
	for i in range(1,5):
		var pt1 = grid[point_path[i-1]]
		var pt2 = grid[point_path[i]]
		var path = astar.get_point_path(pt1, pt2)
		for l in range(1, path.size()-1):
			var cellcheck = get_cell(path[l].x, path[l].y)
			if cellcheck==1:
				set_cell(path[l].x, path[l].y, 0)
			var lNeighbor = get_cell(path[l].x-1, path[l].y)
			var rNeighbor = get_cell(path[l].x+1, path[l].y)
			if (lNeighbor<2 or rNeighbor<2):
				set_cell(path[l].x,path[l].y+1, 0)
				set_cell(path[l].x,path[l].y-1, 0)
			var uNeighbor = get_cell(path[l].x, path[l].y+1)
			var dNeighbor = get_cell(path[l].x, path[l].y-1)
			if(uNeighbor<2 or dNeighbor<2):
				set_cell(path[l].x+1,path[l].y, 0)
				set_cell(path[l].x-1,path[l].y, 0)

#	One final connection down here to get from the end of the path back to the 
	var final_path = astar.get_point_path(grid[point_path[4]], grid[point_path[0]])
	for l in range(1,final_path.size()-1):
		var cellcheck = get_cell(final_path[l].x, final_path[l].y)
		if cellcheck==1:
			set_cell(final_path[l].x, final_path[l].y, 0)
		var lNeighbor = get_cell(final_path[l].x-1, final_path[l].y)
		var rNeighbor = get_cell(final_path[l].x+1, final_path[l].y)
		if (lNeighbor<2 or rNeighbor<2):
			set_cell(final_path[l].x,final_path[l].y+1, 0)
			set_cell(final_path[l].x,final_path[l].y-1, 0)
		var uNeighbor = get_cell(final_path[l].x, final_path[l].y+1)
		var dNeighbor = get_cell(final_path[l].x, final_path[l].y-1)
		if(uNeighbor<2 or dNeighbor<2):
			set_cell(final_path[l].x+1,final_path[l].y, 0)
			set_cell(final_path[l].x-1,final_path[l].y, 0)

#	Finally, we translate the tilemap coordinates to world space (so that we can
#	use them for later calculations) and put them into an array. We also paint 
#	our road markers back onto the map.
	state_count = 0
	for i in range(point_path.size()):
		set_cell(point_path[i].x,point_path[i].y, 2+i)
		screen_points.append(map_to_world(point_path[i], false)+cell_size / 2)
	pass
