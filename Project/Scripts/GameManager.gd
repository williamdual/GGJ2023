extends Node2D

var placementSound = load("res://Sounds/fishy.wav")
var newRoundSound = load("res://Sounds/pop1.wav")
var selectElementSound = load("res://Sounds/selectElt.wav")
var evolveSound = load("res://Sounds/construction.wav")
var gameOver = false
#loto stuff
var lotoPool = []
var currentHand = []
var handSize = 3
var rng = RandomNumberGenerator.new()

#choice stuff
var spritePath = "res://Sprites/ElementSprites/" #fill this in
var choice = load("res://Scenes/Choice.tscn")
var win_size
#GM stuff
var score = 0

#signal stuff
#signal add_to_raffle
#signal add_score
signal player_chose
signal unclicked

func _ready():
	win_size = get_viewport().get_visible_rect().size
	#choice background stuff
	get_node("ChoiceBackgroundSprite").global_position = Vector2(win_size.x/2, win_size.y-60)
	get_node("ChoiceBackgroundSprite").scale = Vector2(3,3)
	#signal connections
	#connect("add_to_raffle", self,  "addLoto")
	#connect("add_score", self, "addToScore")
	#connect("element_placed", self, "setTimerForNextTurn")
	initalizeLotoPool()
	#startTurn()


func startTurn():
	drawLoto()
	drawHand()

func setTimerForNextTurn():
	for i in currentHand:
		get_node("choice"+str(i)).queue_free()
	currentHand.clear()
	$TurnTimer.start(.95);
	playPlacementSound()

#hide haha
func drawHand():
	var cntr = 0
	for i in handSize:
		var child = choice.instance()
		child.get_node("Sprite").texture = load(spritePath+"/"+str(currentHand[cntr])+".png")
		child.global_position = Vector2((win_size.x/2)-80+(cntr*80), win_size.y-60)
		child.get_node("Sprite").scale = Vector2(4,4)
		child.setName(currentHand[i]) #name of element
		child.name = "choice"+str(currentHand[i]) #name of node in godot editor
		add_child(child)
		cntr+=1

func pickElement(n, checked):
	playSelectElementSound()
	for i in currentHand:
		if i != n:
			i = "choice"+i
			get_node(i).checked = false 
			get_node(i).get_node("Area2D").get_node("Hightlight").visible = false
	if(checked):
		emit_signal("player_chose", n)
	else:
		emit_signal("unclicked")



func drawLoto():
	for i in handSize:
		rng.randomize()
		var c = lotoPool[rng.randi_range(0, lotoPool.size()-1)]
		while(c in currentHand):
			c = lotoPool[rng.randi_range(0, lotoPool.size()-1)]
		currentHand.append(c)

func addLoto(toAdd:String, num:int):
	print("adding " + str(num) + " " + toAdd + " entries to the raffle")
	for i in num:
		lotoPool.append(toAdd)

func addToScore(scoreToAdd:int):
	print("adding " + str(scoreToAdd) + " to the score")
	score += scoreToAdd
	print("TOTAL SCORE: " + str(score))

func initalizeLotoPool(): #named after adult stage, if has any
	for i in 8:
		lotoPool.append("water")
	for i in 5:
		lotoPool.append("acorn")
	for i in 2:
		lotoPool.append("egg")
	for i in 1:
		lotoPool.append("mushroom")
	for i in 2:
		lotoPool.append("seed")

func _on_Board_element_placed():
	if(not gameOver):
		setTimerForNextTurn()
	

func _on_TurnTimer_timeout():
	if(not gameOver):
		playNewRoundSound()
		startTurn()

func playPlacementSound():
	$AudioStreamPlayer.volume_db = 4
	$AudioStreamPlayer.stream = placementSound
	$AudioStreamPlayer.play()
func playNewRoundSound():
	$AudioStreamPlayer.volume_db = 0
	$AudioStreamPlayer.stream = newRoundSound
	$AudioStreamPlayer.play()
func playSelectElementSound():
	$AudioStreamPlayer.volume_db = 6
	$AudioStreamPlayer.stream = selectElementSound
	$AudioStreamPlayer.play()
func playEvolveSound():
	$EvolutionStreamPlayer.volume_db = 6
	$EvolutionStreamPlayer.stream = evolveSound
	$EvolutionStreamPlayer.play()


func _on_BackgroundStreamPlayer_finished():
	$BackgroundStreamPlayer.play()


func _on_board_full():
	gameOver = true
