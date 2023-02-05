extends KinematicBody2D
var elementName = ""


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setName(n):
	elementName = n

func _on_Area2D_input_event(viewport, event, shape_idx):
	if(event is InputEventMouseButton):
		$Area2D/Hightlight.visible = true
		self.get_parent().pickElement(name)
