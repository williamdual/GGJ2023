extends Node


var tiles : Array 
var grid : Array 
var width = 30
var height = 15
var tileSize : int  = 40

func get_tile_at():
	return

# shows all tiles where elements can be placed 
func highlight_free():
	return 

# Called when the node enters the scene tree for the first time.
func _ready():
	print(get_in_range(1,1,1))
	

#range 1 = 8 surrounding tiles
#range 2 = 16 surrohnding tiles 
#range 3 = 24 surrounding tiles 
func get_in_range(start_x,start_y, tile_range):
	var tilesInRange : Dictionary = {}
	for x in range(start_x):
		for y in range(start_y):
			if (x < 0) or (x >= width) or (y < 0) or (y >= height):
				continue
			if (tilesInRange.has(tiles[x][y].getType())):
				var elementType = tiles[x][y].getType()
				tilesInRange[tiles[x][y].getType()] = tilesInRange[tiles[x][y].getType()] + 1
			
	#loop through surrounding tiles and check for elements 
	#return a dictionary with how many there are of each time, in case there are score multipliers based on x amount 	
	return tilesInRange

func init_grid():
	for x in range(height): 	
		grid.append([])
		for y in range(width):
			grid[x].append([])
			grid[x][y] = Vector2(x*tileSize, y*tileSize)	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
