extends Node2D

#Sprite Stuff
export (Texture) var elementTexture
export (Texture) var infantTexture
var grassTexture = "res://Sprites/Grass.png"
var score = 0
#state management
export var infantTileName:String = "Grass"
export var evolvedTileName:String = "Grass"
var tileName = "Grass"
export var grown = false
var isGrass = false
var hasElement = false
var pos = []
var numTiles = 1 #number of this tile on the board
	#Parralell arrays: the name of the tile, the min amount you need
export var evolveName:PoolStringArray = []
export var evolveRequiredAmounts:PoolIntArray = []
export var evolveRanges:PoolIntArray = []
var currentEvolveTiles:PoolIntArray = []

export var scoreName:PoolStringArray = []
export var scoreGiven:PoolIntArray = []
var currentScoreTiles:PoolIntArray = []

export var raffleNamesToAdd:PoolStringArray = []
export var raffleNumsToAdd:PoolIntArray = []

#signals
signal add_score
signal add_to_raffle
#TODO tile that is being placed has no info on what is around it

# Called when the node enters the scene tree for the first time.
#score for new element
func _ready():
	tileName = infantTileName
	$Sprite.texture = infantTexture
	add_to_group("Tiles")
	if(isGrass):
		$Sprite.texture = grassTexture
	#should we show it as an infant for a bit (2 secs) and then evolve it in front of the player's eyes?

#override this?
func grow(): 
	#need to unlock score
	tileName = evolvedTileName
	$Sprite.texture = elementTexture
	grown = true 
	updateScore(score)
	#tell game manager to add raffle if needed
	for i in range(raffleNamesToAdd.size()):
		emit_signal("add_to_raffle", raffleNamesToAdd[i], raffleNumsToAdd[i])


func canGrow() -> bool: #checks all of the conditions agenst the map
	var allGood = true;
	for i in range(evolveName.size()):
		if(currentEvolveTiles[i] < evolveRequiredAmounts[i]):
			allGood = false
			break
	return allGood

#update score!
func newTileWithinRange(newTile, tileRange):
	#is this tile relevant to me? evolve, score
	for i in range(evolveName.size()):
		if(evolveName[i] == newTile and tileRange <= evolveRanges[i]):
			currentEvolveTiles[i]+=1
	if(canGrow()):
		grow()
	for i in range(scoreName.size()):
		if(scoreName[i] == newTile):
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
	emit_signal("add_score", byThisAmount)

#GETTERS
func getName() -> String:
	return tileName
func getPos() -> Array:
	return pos

func highlight_off():
	$Area2D/Hightlight.visible = false
	
func highlight_on():
	$Area2D/Hightlight.visible = true

func _on_Area2D_mouse_entered():
	highlight_on()

func _on_Area2D_mouse_exited():
	highlight_off()
