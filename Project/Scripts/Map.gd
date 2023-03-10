extends Node2D

var tiles : Array #holds tile names 
var grid : Array #holds all tile positions 
var tile_types : Array #holds the actual tile objects
var tileSize : int  = 64
var screen_width :int 
var screen_height : int
var width : int 
var height : int  

var tilesPlaced:int = 0

var tileEffectRange = 2
var clickedTile = "Tile"
var Tile = preload("res://Scenes/Element Scenes/Tile.tscn")

var choosing = false


signal element_placed
signal board_full

func get_tile_at():
	return

# shows all tiles where elements can be placed 
func highlight_free():
	for x in range(width):
		for y in range(height):
			if tile_types[x][y].getName() == "grass":
				tile_types[x][y].highlight_on()
			
	return 

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_width  = get_viewport().get_visible_rect().size.x	
	screen_height = get_viewport().get_visible_rect().size.y - 100
	width  = screen_width/tileSize
	height = screen_height/tileSize
	connect("player_chose",self, "set_clicked")
	init_grid()
	populate_board()
	return 

#get type from clicked tile (from available tiles to place on board) 
func set_clicked(type):
	clickedTile = type 
	choosing = true
	return



#will send a signal to every single element in the range 
func tile_placed(x,y,name):
	var arrayx = x
	var arrayy = y
	var surroundingTiles : Array = []
	x-=2
	y-=2
	for i in range((tileEffectRange*2)+1):
		for j in range((tileEffectRange*2)+1):
			if (x+i<0) or (x+i>= width) or (y+j<0) or (y+j >= height) or ((x+i) == arrayx && y+j == arrayy):
				continue
			#if tile_types[x+i][y+j].getName() != "Grass":
			tile_types[x+i][y+j].newTileWithinRange(name, max(abs(x+i - arrayx),abs(y+j - arrayy)))
			#new tile gets affected too
			tile_types[arrayx][arrayy].newTileWithinRange(tile_types[x+i][y+j].getName(), max(abs(x+i - arrayx),abs(y+j - arrayy)))

	clickedTile = ""
	emit_signal("element_placed")
	return #array	


func get_in_range(start_x,start_y, tile_range):
	var tilesInRange : Dictionary = {}
	for x in range(start_x):
		for y in range(start_y):
			if (x < 0) or (x >= width) or (y < 0) or (y >= height):
				continue
			if (tilesInRange.has(tiles[x][y].getType())):
				var elementType = tiles[x][y].getType()
				tilesInRange[elementType] = tilesInRange[elementType] + 1
	return tilesInRange

func init_grid():
	for x in range(width): 	
		grid.append([])
		tiles.append([])
		tile_types.append([])
		for y in range(height):
			grid[x].append([])
			grid[x][y] = Vector2(x*tileSize, y*tileSize)	
			tiles[x].append([])
			tiles[x][y] = ""

func populate_board():
	for x in range(width):
		tile_types.append([])
		for y in range(height):
			var tile_to_add = load("res://Scenes/Element Scenes/" + clickedTile + ".tscn").instance()
			tile_to_add.position = grid[x][y]
			tiles[x][y] = "grass"
			add_child(tile_to_add)
			tile_types[x].append([])
			tile_types[x][y] = tile_to_add

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if clickedTile == "":
			return
		if choosing: 
			var x_pos = get_viewport().get_mouse_position().x
			var y_pos = get_viewport().get_mouse_position().y
			if within_x_bounds(x_pos) and within_y_bounds(y_pos): 
				if tile_types[floor((x_pos)/tileSize)][floor((y_pos)/tileSize)].getName() == "grass":
					spawn_tile()
					choosing = !choosing
	
func within_x_bounds(x):
	return x > 0 and x <= screen_width 
	
func within_y_bounds(y):
	return y > 0 and y <= screen_height 


func spawn_tile():
	var tile = load("res://Scenes/Element Scenes/" + clickedTile + ".tscn")
	var tile_to_place = tile.instance()
	var x_pos = floor(get_viewport().get_mouse_position().x/tileSize)
	var y_pos = floor(get_viewport().get_mouse_position().y/tileSize)
	tile_to_place.position = Vector2(x_pos*tileSize, y_pos*tileSize)
	var tile_to_delete = tile_types[x_pos][y_pos]
	tile_types[x_pos][y_pos] = tile_to_place
	tiles[x_pos][y_pos] = clickedTile
	add_child(tile_to_place)
	tile_placed(x_pos, y_pos, clickedTile)
	tilesPlaced+=1
	if(tilesPlaced >= width*height):
		emit_signal("board_full")


func _on_GameManager_player_chose(n):
	set_clicked(n)

func _process(delta):
	if choosing: 
		highlight_free()
	else:
		highlight_none()
		
func highlight_none():
	for x in range(width):
		for y in range(height):
			if tile_types[x][y].getName() == "grass":
				tile_types[x][y].highlight_off()

func elementEvolved(elemName, elemTileName):
	for i in range(width):
		for j in range(height):
			if(tile_types[i][j].name == elemName):
				tile_types[i][j].setName(elemTileName)
				tile_placed(i, j, elemTileName)
#name, tilename


func _on_GameManager_unclicked():
	clickedTile = ""
	choosing = false
