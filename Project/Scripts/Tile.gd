extends Node2D

#Sprite Stuff
export var elementTexture = "Sprites/"
export var infantTexture = "Sprites/"
var grassTexture = "res://Sprites/Grass.png"
var score = 0
#state management
export var infantTileName:String = "name"
export var evolvedTileName:String = "name"
export var tileType:String = "type"
var tileName
var grown = false
export var isGrass = false
var hasElement = false
var pos = []
var numTiles = 1 #number of this tile on the board
	#Parralell arrays: the name of the tile, the min amount you need
export var evolveNameOrTypes:PoolStringArray = []
export var evolveRequiredAmounts:PoolIntArray = []
export var evolveRanges:PoolIntArray = []
var currentEvolveTiles:PoolIntArray = []

export var scoreNameOrTypes:PoolStringArray = []
export var scoreGiven:PoolIntArray = []
var currentScoreTiles:PoolIntArray = []

export var raffleNamesToAdd:PoolStringArray = []
export var raffleNumsToAdd:PoolIntArray = []

# Called when the node enters the scene tree for the first time.
func _ready():
	tileName = infantTileName
	#$Sprite.texture = infantTexture
	add_to_group("Tiles")
	if(isGrass):
		$Sprite.texture = grassTexture
	#should we show it as an infant for a bit (2 secs) and then evolve it in front of the player's eyes?
	elif(canGrow()):
		grow()


func search(): #accesses the grid and grabs the positions of all tiles to see if it meets the grow conditions
	pass

#override this?
func grow(): 
	#need to unlock score
	tileName = evolvedTileName
	#$Sprite.texture = elementTexture
	grown = true 
	updateScore(score)
	#tell game manager to add raffle if needed

func canGrow() -> bool: #checks all of the conditions agenst the map
	var allGood = true;
	for i in range(evolveNameOrTypes.size()):
		if(currentEvolveTiles[i] < evolveRequiredAmounts[i]):
			allGood = false
			break
	return allGood

#update score!
func newTileWithinRange(newTile, tileRange):
	#is this tile relevant to me? evolve, score
	for i in range(evolveNameOrTypes.size()):
		if(evolveNameOrTypes[i] == newTile and tileRange <= evolveRanges[i]):
			currentEvolveTiles[i]+=1
	if(canGrow()):
		grow()
	for i in range(scoreNameOrTypes.size()):
		if(scoreNameOrTypes[i] == newTile):
			currentScoreTiles[i] += 1
			addScore(scoreGiven[i])

#caled everytime a new tile gives score points
func addScore(toAdd):
	score += toAdd
	if(grown):
		updateScore(toAdd)
	return

#tells gameManager to update score by this amount
func updateScore(byThisAmount):
	return

#GETTERS
func getName() -> String:
	return tileName
func getPos() -> Array:
	return pos
func getType():
	return tileType


func _on_Area2D_mouse_entered():
	$Area2D/Hightlight.visible = true

func _on_Area2D_mouse_exited():
	$Area2D/Hightlight.visible = false
