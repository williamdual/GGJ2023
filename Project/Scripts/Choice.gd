extends KinematicBody2D
var elementName = ""


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _input(event):
	if(event.type == InputEvent.MOUSE_BUTTON && event.button_index == BUTTON_LEFT):
		self.get_parent().pickElement(name)

	
func setName(n):
	elementName = n
