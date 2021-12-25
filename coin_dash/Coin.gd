extends Area2D

var screensize

# If coin gets picked up, play pick-up tween
func pickup():
	# Prevent from emitting signals to avoid calling pickup() while tween is playing
	# Monitoreable: propoerty of Area node that determines if other areas can detect it
	monitorable = false
	# Start tween, make coin increase size and fade
	$Tween.start()
	

# Called when the node enters the scene tree for the first time.
func _ready():
	# Set Tween to interpolate scale and opacity of the sprite upon called
	$Tween.interpolate_property($AnimatedSprite, "scale",  $AnimatedSprite.scale, $AnimatedSprite.scale * 3, 0.3, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($AnimatedSprite, "modulate",  Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.3, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)


# When tweens finish playing, delete coin
func _on_Tween_tween_all_completed():
	queue_free() # Puts the node in a deletion queue so it can be eliminated at the end of the current frame
