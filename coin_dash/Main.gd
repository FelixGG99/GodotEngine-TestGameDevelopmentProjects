extends Node

# Variables set up from the Inspector tab for the Main node
export (PackedScene) var Coin	# Coin scene object to be able to instace in code
export (int) var playtime		# Duration of the round

# Node Variables
var level
var score
var time_left
var screensize
var playing = false

func _ready():
	# Set a random seed for the RNG
	randomize() 
	# Get the screensize from the size of the visible rectangle representing the viewport the node resides in
	screensize = get_viewport().get_visible_rect().size
	# Set Player properties
	$Player.screensize = screensize
	$Player.hide()

func spawn_coins():
	# Spawn as many coins as the current level plus 4
	for _i in range (4 + level):
		# Instance a new coin and add it to CoinContainer
		var new_coin = Coin.instance()
		$CoinContainer.add_child(new_coin)
		# Set variable values for the new coin
		new_coin.screensize = screensize
		new_coin.position = Vector2(rand_range(0, screensize.x), rand_range(0, screensize.y))

# Connected to the start_game signal (button pressing)
func new_game():
	# Set up game variables
	playing = true
	level = 1
	score = 0
	time_left = playtime
	# Set up Player's starting position and visibility
	$Player.start($PlayerStart.position)
	$Player.show()
	# Start timer and coin instancing
	$GameTimer.start()
	spawn_coins()
	# Initialize score and timer
	$HUD.update_score(score)
	$HUD.update_timer(time_left)
	
func check_for_next_level():
	# If no coins left in container, advance to the next level, increase time and spawn coins
	if $CoinContainer.get_child_count() == 0:
		level += 1
		time_left += 5
		# Play Next Level sound
		$NextLevelSound.play()
		spawn_coins()
		
func _process(delta):
	# Update time and check for level completition IF the game has started
	if playing:
		# Check if player advances to next level
		check_for_next_level()
	
# Callback function reacting to Player's pickup signal
func _on_Player_pickup():
	# Play coin pickup sound
	$PickupCoinSound.play()
	# Increase Score and update HUD counter
	score += 1
	$HUD.update_score(score)

# Callback function reacting to Player's hurt signal	
func _on_Player_hurt():
	game_over()

# Callback function reacting to GameTimer's timeout signal
func _on_GameTimer_timeout():
	# Decrease time_left and update HUD timer
	time_left -= 1
	$HUD.update_timer(time_left)
	# If time_left reaches zero, end game
	if time_left <= 0:
		game_over()

# End game and show game over screen
func game_over():
	# Play end sound
	$EndSound.play()
	# Set playing flag to false
	playing = false
	# Stop GameTimer
	$GameTimer.stop()
	# Delete every coin instance
	for coin in $CoinContainer.get_children():
		coin.queue_free()
	# Show Game Over message
	$HUD.show_game_over()
	# Play player dying animation
	$Player.die()
