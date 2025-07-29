# Inherits from the "Enemy" class, so it can reuse the functionality of the parent class
extends "res://scripts/enemy.gd"

class_name EnemySplitter

# A scene for the mini bots that will be spawned upon enemy death
@export var mini_bot_scene: PackedScene
# The number of mini bots to spawn upon enemy death
@export var mini_bot_count: int = 3

func _ready():
	# Call the parent class's _ready() function to ensure that the inherited logic runs
	super._ready()
	# If "MuzzleEnemy" node exists in the scene, assign it to the muzzle_enemy variable
	if has_node("MuzzleEnemy"):
		muzzle_enemy = $MuzzleEnemy

func _physics_process(delta):
	# Call the parent class's _physics_process() to preserve inherited functionality
	super._physics_process(delta) 
	# Move the enemy down the screen based on the speed and elapsed time (delta)
	global_position.y += speed * delta

func die():
	# Call the deferred function to spawn mini bots and free the current enemy node
	call_deferred("_spawn_mini_bots_and_free")

# Function to spawns a number of mini bots based on the mini_bot_count variable. 
# It randomly offsets their positions and adds them to the scene, then frees the current enemy node.
func _spawn_mini_bots_and_free():
	# Loop to spawn mini bots based on the mini_bot_count
	for i in range(mini_bot_count):
		# Instantiate a new mini bot from the preloaded scene
		var bot = mini_bot_scene.instantiate()
		# Randomly offset the position of the mini bot around the current position
		bot.global_position = global_position + Vector2(randf_range(-20, 20), randf_range(-20, 20))
		# Add the mini bot to the parent node (the enemy's parent)
		get_parent().add_child(bot)
	# Free the current enemy node after spawning mini bots
	queue_free()

func _on_body_entered(body):
	if body is ShipPlayer:
		body.die()
		die()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
