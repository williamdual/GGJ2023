extends Node2D


#loto stuff
var lotoPool = []
var currentHand = []
var handSize = 3
var rng = RandomNumberGenerator.new()

#choice stuff
var spritePath = "res://Sprites/ElementSprites/" #fill this in
var choice = load("res://Scenes/Choice.tscn")

#GM stuff
var score = 0

#signal stuff
signal add_to_raffle
signal add_score
signal element_placed
signal player_chose
func _ready():
	#signal connections
	connect("add_to_raffle", self,  "addLoto")
	connect("add_score", self, "addToScore")
	connect("element_placed", self, "setTimerForNExtTurn")
	initalizeLotoPool()
	#startTurn()


func startTurn():
	drawLoto()
	drawHand()

func setTimerForNextTurn():
	$TurnTimer.start(2);

#hide haha
func drawHand():
	var cntr = 0
	var win_size = get_viewport().get_visible_rect().size
	for i in handSize:
		var child = choice.instance()
		child.get_node("Sprite").texture = load(spritePath+"/"+str(currentHand[cntr])+".png")
		child.global_position = Vector2((win_size.x/2)-80+(cntr*80), win_size.y-50)
		child.get_node("Sprite").scale = Vector2(4,4)
		child.setName(currentHand[i]) #name of element
		child.name = "choice"+str(currentHand[i]) #name of node in godot editor
		add_child(child)
		cntr+=1

func pickElement(n):
	for i in currentHand:
		if i != n:
			i = "choice"+i
			get_node(i).checked = false 
			get_node(i).get_node("Area2D").get_node("Hightlight").visible = false
	emit_signal("player_chose", n)



func drawLoto():
	for i in handSize:
		rng.randomize()
		var c = lotoPool[rng.randi_range(0, lotoPool.size()-1)]
		while(c in currentHand):
			c = lotoPool[rng.randi_range(0, lotoPool.size()-1)]
		currentHand.append(c)

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
	for i in 7:
		lotoPool.append("egg")
	#etc etc



func _on_TurnTimer_timeout():
	startTurn()
