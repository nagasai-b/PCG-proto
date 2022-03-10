extends TileMap

const N = 1
const E = 2
const S = 4
const W = 8

var cell_walls = {Vector2(0,-2): N, Vector2(2,0): E, Vector2(0,2): S, Vector2(-2, 0): W}

var tile_size = 64
var width = 16
var height = 10

var map_seed = 0
func check_neighbors(cell, unvisited):
	var list = []
	for n in cell_walls.keys():
		if cell+n in unvisited:
			list.append(cell + n)
	return list
	
func _ready():
	randomize()
	if !map_seed:
		map_seed = randi()
	seed(map_seed)
	print(map_seed)
	tile_size = cell_size
	
	make_maze()
	generate_game()

func make_maze():
	var unvisited = []
	var stack = []
	
	clear()
	for x in range(width):
		for y in range(height):
			set_cellv(Vector2(x,y), N|E|S|W)
	for x in range(0, width, 2):
		for y in range(0, height, 2):
			unvisited.append(Vector2(x,y))
	var current = Vector2(0,0)
	unvisited.erase(current)
	while unvisited:
		var neighbors = check_neighbors(current, unvisited)
		if neighbors.size() > 0:
			var next = neighbors[randi() % neighbors.size()]
			stack.append(current)
			var dir = next - current
			var current_walls = get_cellv(current) - cell_walls[dir]
			var next_walls = get_cellv(next) - cell_walls[-dir]
			set_cellv(current, current_walls)
			set_cellv(next, next_walls)
			if dir.x != 0:
				set_cellv(current + dir/2, 5)
			else:
				set_cellv(current + dir/2, 10)
			current = next
			unvisited.erase(current)
		elif stack:
			current = stack.pop_back()

func generate_game():
	var x = int(rand_range(1, width - 1))
	var y = int(rand_range(1, height - 1))
	set_cellv(Vector2(x,y), 16)
	
