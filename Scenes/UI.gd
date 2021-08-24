extends CanvasLayer

onready var label = $"Power Meter"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_Player_force_changed(new_force):
	label.text = str(new_force)
