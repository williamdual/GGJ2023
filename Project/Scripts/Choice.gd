extends KinematicBody2D
var elementName = ""
var checked = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setName(n):
	elementName = n

func _on_Area2D_input_event(viewport, event, shape_idx):
	if(event is InputEventMouseButton and event.pressed):
		$Area2D/Hightlight.visible = true
		checked = !checked
		self.get_parent().pickElement(elementName)

func _on_Area2D_mouse_exited():
	if(!checked):
		$Area2D/Hightlight.visible = false


func _on_Area2D_mouse_entered():
	$Area2D/Hightlight.visible = true
