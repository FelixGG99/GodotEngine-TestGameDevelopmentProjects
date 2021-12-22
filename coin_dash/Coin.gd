extends Area2D

var screensize

# If coin gets picked up, delete node from scene tree
func pickup():
	queue_free() # Puts the node in a deletion queue so it can be eliminated at the end of the current frame

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

