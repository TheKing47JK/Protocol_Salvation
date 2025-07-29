extends Node2D

# Reference to the player's ship node 
@onready var ship: CharacterBody2D = $Ship

# Reference to the spawn position for the player
@onready var player_spawn_position: Marker2D = $PlayerSpawnPosition

# Container for holding laser objects
@onready var laser_container: Node2D = $LaserContainer

# Timer for controlling enemy spawn intervals
@onready var enemy_spawn_timer: Timer = $EnemySpawnTimer

# Container for holding enemy objects
@onready var enemy_container: Node2D = $EnemyContainer

# Array to hold different enemy scene types
@export var enemy_scenes: Array[PackedScene] = []

var easy_enemies: Array[PackedScene] = [] # Stores easy enemies
var medium_enemies: Array[PackedScene] = [] # Stores medium enemies
var hard_enemies: Array[PackedScene] = [] # Stores hard enemies

# Time when the game started, to control enemy spawning and difficulty scaling
var game_start_time: float = 0.0
var easy_weight := 1.0  # Weight for easy enemies (controls spawn probability)
var medium_weight := 0.0  # Weight for medium enemies
var hard_weight := 0.0  # Weight for hard enemies

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Set the player's ship to the spawn position when the scene is ready
	ship.global_position = player_spawn_position.global_position
	
	# Connect the laser_shoot signal to the laser_shot function to handle laser firing
	ship.laser_shoot.connect(laser_shot)
	
	# Classify enemy scenes based on difficulty
	easy_enemies = [enemy_scenes[0]]  # First enemy scene is easy
	medium_enemies = [enemy_scenes[1]]  # Second enemy scene is medium
	hard_enemies = [enemy_scenes[2]]  # Third enemy scene is hard
	
	# Set the enemy spawn timer's wait time to be random between 2 and 3 seconds
	enemy_spawn_timer.wait_time = randf_range(2.0, 3.0)
	
	# Record the game start time
	game_start_time = Time.get_ticks_msec() / 1000.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# Check for quit or reset inputs
	if Input.is_action_just_pressed("quit"):
		get_tree().quit() # Exit the game
	elif Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene() # Reload the current scene
		
	# Calculate how much time has passed since the start of the game
	var time_passed = Time.get_ticks_msec() / 1000.0 - game_start_time
	
	# If more than 30 seconds have passed, decrease the enemy spawn interval
	if time_passed > 30 and enemy_spawn_timer.wait_time > 1.5:
		enemy_spawn_timer.wait_time = 2.0

# Function to handle laser shooting, it instantiates a laser and adds it to the container
func laser_shot(laser_scene,location):
	var laser = laser_scene.instantiate() # Instantiate the laser from the provided scene
	laser.global_position = location # Set the laser's position to the provided location
	laser_container.add_child(laser) # Add the laser to the laser container
	
# Function to handle enemy laser shooting, similar to player laser shooting
func laser_enemy_shot(laser_enemy_scene, location):
	var laser = laser_enemy_scene.instantiate()
	laser.global_position = location
	laser_container.add_child(laser)

# Function called when the enemy spawn timer runs out
func _on_enemy_spawn_timer_timeout() -> void:
	# Calculate the time that has passed since the game started
	var current_time = Time.get_ticks_msec() / 1000.0
	var time_passed = current_time - game_start_time
	
	# Determine which enemies are available to spawn based on how much time has passed
	var available_enemies = []
	
	if time_passed < 30: # Only easy enemies for the first 30 seconds
		available_enemies = easy_enemies
	elif time_passed < 60: # Easy + medium enemies between 30s and 60s
		available_enemies = easy_enemies + medium_enemies
	else: # All enemies after 60s
		available_enemies = easy_enemies + medium_enemies + hard_enemies
	
	# Select an enemy scene to spawn based on the weighted probability
	var enemy_scene = get_weighted_enemy_scene()
	# Instantiate the selected enemy scene
	var enemy = enemy_scene.instantiate()
	
	# If the enemy can shoot, connect its laser shooting signal to the laser_enemy_shot function
	if enemy.has_signal("laser_enemy_shoot"):
		enemy.laser_enemy_shoot.connect(laser_enemy_shot)
	
	# Set the enemy's initial position at a random point above the screen
	enemy.global_position = Vector2(randf_range(50, 700), -50)
	# Add the enemy to the enemy container
	enemy_container.add_child(enemy)

# Function to get a randomly selected enemy scene based on the weighted probabilities
func get_weighted_enemy_scene() -> PackedScene:
	update_weights() # Update the weights first
	
	# Calculate the total weight of all enemy types
	var total = easy_weight + medium_weight + hard_weight
	var rand_val = randf() * total # Generate a random value to select an enemy
	
	# Select the enemy based on the weighted probabilities
	if rand_val < easy_weight:
		return easy_enemies.pick_random() # Pick a random easy enemy
	elif rand_val < easy_weight + medium_weight:
		return medium_enemies.pick_random() # Pick a random medium enemy
	else:
		return hard_enemies.pick_random() # Pick a random hard enemy

# Function to update the weights for different types of enemies
func update_weights():
	var time_passed = (Time.get_ticks_msec() / 1000.0) - game_start_time
	
	# Update the weights based on the time passed to gradually increase the frequency of harder enemies
	easy_weight = clamp(1.0 - time_passed / 60.0, 0.2, 1.0) # Easy weight decreases over time
	medium_weight = clamp(time_passed / 60.0, 0.0, 1.0) # Medium weight increases after 30 seconds
	hard_weight = clamp((time_passed - 60.0) / 60.0, 0.0, 1.0) # Hard weight increases after 60 seconds
