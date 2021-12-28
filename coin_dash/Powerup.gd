extends Area2D

var screensize

# When picked up, make non-monitoreable to avoid processing same signal and play tween
func pickup():
	monitorable = false
	$Tween.start()

func _ready():
	
	# Set new random animation delay (no need for first animation due to short lifetime)
	$AnimationDelay.wait_time = rand_range(0, 5)
	$AnimationDelay.start()
	
	# Set scale and opacity tweens
	$Tween.interpolate_property($AnimatedSprite, "scale", $AnimatedSprite.scale, $AnimatedSprite.scale * 3, 0.3, $Tween.TRANS_QUAD, $Tween.EASE_IN_OUT)
	$Tween.interpolate_property($AnimatedSprite, "modulate", Color(1, 1, 1, 1), Color (1, 1, 1, 0), 0.3, $Tween.TRANS_QUAD, $Tween.EASE_IN_OUT)


# Play animation when delay times out
func _on_AnimationDelay_timeout():
	$AnimatedSprite.frame = 0
	$AnimatedSprite.play()

# If powerup spawned in cactus, change position
func _on_Powerup_area_entered(area):
	if area.is_in_group("obstacles"):
		position = Vector2(rand_range(0, screensize.x), rand_range(0, screensize.y))

# Delete instance once its lifetime runs out
func _on_Lifetime_timeout():
	queue_free()
