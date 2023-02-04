extends Node2D


#loto stuff
var lotoPool = []
var currentHand = []
var handSize = 3
var rng = RandomNumberGenerator.new()

#choice stuff
var spritePath = "Sprites/" #fill this in
var choice = load("res://Choice.tscn")

#GM stuff
var score = 0

func _ready():
	#signal connections
	connect("add_to_raffle", self,  "addLoto")
	connect("add_score", self, "addToScore")
	initalizeLotoPool()


func startTurn():
	drawLoto()
	drawHand()

func setTimerForNextTurn():
	$TurnTimer.start(2);

func drawHand():
	var cntr = 0
	for i in handSize:
		var child = choice.instance()
		child.sprite.texture = load(spritePath+"/"+currentHand[cntr]+".png")
		child.rect_global_position = Vector2(360+(cntr*40), 520)
		child.scale = 2 
		child.setName(currentHand[i]) #name of element
		child.name = "choice"+i #name of node in godot editor
		add_child(child)
		cntr+=1

func pickElement(n):
	emit_signal("player_chose", n)
	pass



func drawLoto():
	for i in handSize:
		rng.randomize()
		currentHand.append(rng.randi_range(0, lotoPool.size()-1))

func addLoto(toAdd:String, num:int):
	for i in num:
		lotoPool.append(toAdd)

func addToScore(scoreToAdd:int):
	score += scoreToAdd

func initalizeLotoPool(): #named after adult stage, if has any
	for i in 5:
		lotoPool.append("water")
	for i in 10:
		lotoPool.append("acorn")
	#etc etc

