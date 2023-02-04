extends Node2D

var t = 0
var speed = 1.25 #can change this var to change how fast it scales up

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#dont change anything here except for var b
	t += delta*speed
	var a = 0 
	var b = 0.7 #lower this to make the 'max scale' smaller, increase to make it bigger
	var temp = a * (1-t) + b*t 
	scale.x = temp
	scale.y = temp
	
func set_text(newText):
	$Label.text = newText

func _on_Timer_timeout():
	queue_free()
