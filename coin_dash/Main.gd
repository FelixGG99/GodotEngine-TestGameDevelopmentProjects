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
		spawn_coins()
		
func _process(delta):
	# Update time and check for level completition IF the game has started
	if playing:
		# Check if player advances to next level
		check_for_next_level()
	
func _on_Player_pickup():
	score += 1
	$HUD.update_score(score)
	
func _on_Player_hurt():
	game_over()

func _on_GameTimer_timeout():
	time_left -= 1
	$HUD.update_timer(time_left)
	if time_left <= 0:
		game_over()

func game_over():
	playing = false
	$GameTimer.stop()
	for coin in $CoinContainer.get_children():
		coin.queue_free()
	$HUD.show_game_over()
	$Player.die()
