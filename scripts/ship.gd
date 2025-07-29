class_name ShipPlayer
extends CharacterBody2D

# Declare a custom signal to emit when the ship shoots a laser, 
# passing the laser scene and its location
signal laser_shoot(laser_scene, location)

# Movement speed of the player
@export var speed = 500

# Time between consecutive shots in seconds
@export var rateOfFire = 0.25

# The position from where the laser is shot
@onready var muzzle: Marker2D = $Muzzle

# Reference to the animated sprite for the ship
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

# Variable to control whether the ship can shoot again (used for rate of fire)
var shoot_cd := false

# Preload the laser scene so it can be instantiated later
var laser_scene = preload("res://scenes/laser.tscn")


func _process(_delta: float) -> void:
	# Check if the shoot button is pressed
	if Input.is_action_pressed("shoot"):
		# Ensure the player cannot shoot faster than the rate of fire
		if !shoot_cd:
			shoot_cd = true
			# Call the shoot function to fire a laser
			shoot()
			# Wait for the duration of the rate of fire timer before allowing another shot
			await get_tree().create_timer(rateOfFire).timeout
			# Reset the cooldown flag after the wait
			shoot_cd = false
	# Animate the ship's movement based on input
	animate_the_ship()
	
func _physics_process(_delta: float) -> void:
	# Get the input direction for movement based on player input
	var direction = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down"))
	# Set the velocity to move in the desired direction at the specified speed
	velocity = direction * speed
	
	#make sure the player cannot go out of screen
	var viewRect :=get_viewport_rect()
	position.x = clamp(position.x,0,viewRect.size.x)
	position.y = clamp(position.y,0,viewRect.size.y)
	move_and_slide()
	
func shoot():
	# Emit the laser_shoot signal to notify the game that the player shot a laser
	laser_shoot.emit(laser_scene, muzzle.global_position)

# Based on the player's movement input, 
# this function updates the ship's animation to reflect the direction of movement
func animate_the_ship() -> void:
	if Input.is_action_pressed("move_right"):
		animated_sprite_2d.play("move_right")
	elif Input.is_action_pressed("move_left"):
		animated_sprite_2d.play("move_left")
	else:
		animated_sprite_2d.play("center")
	pass

# Function to handle the player's death
func die():
	# Free the ship object, effectively removing it from the scene
	queue_free()
