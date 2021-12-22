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
	new_game()

func spawn_coins():
	# Spawn as many coins as the current level plus 4
	for _i in range (4 + level):
		# Instance a new coin and add it to CoinContainer
		var new_coin = Coin.instance()
		$CoinContainer.add_child(new_coin)
		# Set variable values for the new coin
		new_coin.screensize = screensize
		new_coin.position = Vector2(rand_range(0, screensize.x), rand_range(0, screensize.y))

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
	
