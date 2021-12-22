extends CanvasLayer

signal start_game

# Function to update the Score control on the HUD
func update_score(value):
	$MarginContainer/ScoreLabel.text = str(value)

# Function to update the Timer control on the HUD
func update_timer(value):
	$MarginContainer/TimeLabel.text = str(value)
	
# Function to update and show a message for two seconds
func show_message(text):
	$MessageLabel.text = text
	$MessageLabel.show()
	# Start the countdown to hide message again
	$MessageTimer.start()

# Function to show the Game Over screen and return to initial screen
func show_game_over():
	# Show Game Over and wait for timer to finish to return to start screen
	show_message("Game Over!")
	yield($MessageTimer, "timeout")
	# Display message and start button without a timer
	$StartButton.show()
	$MessageLabel.text = "Coin Dash!"
	$MessageLabel.show()
	

# Function connected to the timeout of MessageTimer
# Hide MessageLabel control when timer finishes
func _on_MessageTimer_timeout():
	$MessageLabel.hide()

# Function connected to the pressing of the StartButton control
# Hide message and button, send start_game signal
func _on_Button_pressed():
	$MessageLabel.hide()
	$StartButton.hide()
	emit_signal("start_game")

