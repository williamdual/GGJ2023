extends Node2D

var tiles : Array 
var grid : Array #holds all tile positions 
var tileSize : int  = 64
var screen_width = 640	
var screen_height = 512
var width = screen_width/tileSize
var height = screen_height/tileSize

var tileEffectRange = 2
var clickedTile = "Grass"


var Tile = preload("res://Scenes/Tile.tscn")

func get_tile_at():
	return

# shows all tiles where elements can be placed 
func highlight_free():

			
	return 

# Called when the node enters the scene tree for the first time.
func _ready():
	init_grid()
	#populate_board()
	return 

#get type from clicked tile (from available tiles to place on board) 
func clicked_tile_info(type):
	clickedTile = type 
	return


#will send a signal to every single element in the range 
func tile_placed(x,y,type):
	x-=2
	y-=2
	var arrayx = floor((get_viewport().get_mouse_position().x) / tileSize)
	var arrayy = floor((get_viewport().get_mouse_position().y) / tileSize)
	tiles[arrayx][arrayy] = clickedTile
	for i in range(tileEffectRange*2):
		for j in range(tileEffectRange*2):
			if (x<0) or (x>= width) or (y<0) or (y >= height):
				continue
			#tiles[x][y].new_tile_in_range(type, min(x,y))
	return #array	

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
	for x in range(width): 	
		grid.append([])
		tiles.append([])
		for y in range(height):
			grid[x].append([])
			grid[x][y] = Vector2(x*tileSize, y*tileSize)	
			tiles[x].append([])
			tiles[x][y] = "Grass"

func populate_board():
	for x in range(width):
		for y in range(height):
			var tile_to_add = Tile.instance() 
			tile_to_add.position = grid[x][y]
			add_child(tile_to_add)

func _input(event):
	if event is InputEventMouseButton:
		if within_x_bounds(get_viewport().get_mouse_position().x) and within_y_bounds(get_viewport().get_mouse_position().y): 
			spawn_tile()
			tile_placed(get_viewport().get_mouse_position().x, get_viewport().get_mouse_position().y, clickedTile)
	

func within_x_bounds(x):
	return x > 0 and x <= screen_width 
	
func within_y_bounds(y):
	return y > 0 and y <= screen_height 


func spawn_tile():
	var tile_to_place = Tile.instance()
	tile_to_place.position = Vector2(floor(get_viewport().get_mouse_position().x/tileSize)*tileSize, floor(get_viewport().get_mouse_position().y/tileSize)*tileSize)
	add_child(tile_to_place)