extends Area2D

export (int) var speed
var velocity = Vector2()
var screensize = Vector2(480, 720)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_input():
	velocity = Vector2() # Clean vector's components.
	
	# Gets movement direction for each axis
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	
	if velocity.length() > 0: # Transforms direction into speed
		velocity = velocity.normalized() * speed # Normalizes direction vector to avoid moving faster diagonally
		$AnimatedSprite.animation = "run" # Play run anim
		$AnimatedSprite.flip_h = velocity.x < 0 # If moving to the left, flip sprite horizontaly
	else:
		$AnimatedSprite.animation = "idle" # No movement, play idle animation
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	get_input()
	position += velocity * delta
	
