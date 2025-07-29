# allows the enemy to detect when it collides with other objects
extends Area2D
# Assign a class name so this can be referenced by that name in other scripts
class_name Enemy

# Declare exported variables to be adjustable from the editor
# The speed at which the enemy moves (in pixels per second)
@export var speed: float = 200

# Time in seconds between each enemy laser shot
@export var shoot_interval: float = 3

# Initialize the muzzle_enemy node if it exists in the scene (used for laser firing position)
@onready var muzzle_enemy := $MuzzleEnemy if has_node("MuzzleEnemy") else null

# Preload the laser enemy scene to instantiate later
var laser_enemy_scene = preload("res://scenes/laser_enemy.tscn")

# Declare a custom signal to emit when the enemy shoots a laser, passing the laser scene and its location
signal laser_enemy_shoot(laser_enemy_scene, location)

# Declare a variable to track the shooting timer
var shoot_timer := 0.0

func _ready():
	# Check if the node "MuzzleEnemy" exists in the scene and assign it to the muzzle_enemy variable
	if has_node("MuzzleEnemy"):
		muzzle_enemy = $MuzzleEnemy

func _physics_process(delta: float) -> void:
	# Move the enemy downwards based on its speed (increasing y-position)
	global_position.y += speed * delta
	
	# Decrease the shoot timer based on the time that has passed (delta)
	shoot_timer -= delta
	# If the timer reaches zero, the enemy should shoot
	if shoot_timer <= 0:
		shoot_enemy()
		# Reset the shoot timer based on the shoot interval
		shoot_timer = shoot_interval

# Function to handles the actual shooting by emitting a signal 
# that sends the laser's scene and position to be instantiated and fired.
func shoot_enemy():
	# Check if the muzzle_enemy node exists before attempting to shoot
	if muzzle_enemy:
		# Emit the laser_enemy_shoot signal, passing the laser scene and muzzle's global position
		laser_enemy_shoot.emit(laser_enemy_scene, muzzle_enemy.global_position)

# Function to handle the enemy's death
func die():
	# Free the enemy's node, removing it from the scene
	queue_free()

# Called when the enemy collides with another object (body)
func _on_body_entered(body: Node2D) -> void:
	# If the body that collided with the enemy is a ShipPlayer,
	# trigger the player's death and the enemy's death
	if body is ShipPlayer:
		body.die()
		die()

# Called when the enemy goes off the screen
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	# Free the enemy's node when it exits the screen
	queue_free()
