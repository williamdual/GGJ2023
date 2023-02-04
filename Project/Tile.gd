extends Node2D

#Sprite Stuff
export var elementTexture = "Sprites/"
export var infantTexture = "Sprites/"
var grassTexture = "grassLocation"
#state management
export var tileName:String = "name"
var grown = false
export var isGrass = false
var hasElement = false
var pos = []
var numTiles = 1 #number of this tile on the board
	#Parralell arrays: the name of the tile, the min amount you need
export var conditionNames:PoolStringArray = []
export var conditionAmts:PoolStringArray = []
#probability 
export var probCap:int = 25
export var probScalar:float = 1.0
var probWeight

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("Tiles")
	if(isGrass):
		$Sprite.texture = grassTexture
	elif(canGrow()):
		grow()
		$Sprite.texture = infantTexture
		setProb()


func search(): #accesses the grid and grabs the positions of all tiles to see if it meets the grow conditions
	pass

func grow(): 
	$Sprite.texture = infantTexture
	grown = true 

func setProb():
	probWeight = clamp(3*numTiles*probScalar,0,probCap)

func canGrow() -> bool: #checks all of the conditions agenst the map
	return true


#GETTERS
func getName() -> String:
	return name
func getPos() -> Array:
	return pos
func getWeight():
	return probWeight 
