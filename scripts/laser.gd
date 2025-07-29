extends Area2D

# The speed at which the object moves vertically (in pixels per second)
@export var speed = 1000

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Update the vertical position of the object by decreasing it based on the speed 
	# (moving upwards because is for player)
	global_position.y += -speed * delta

# Called when the object goes off the screen (visible area), removing it from the scene
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	# Free the object from the scene, effectively deleting it
	queue_free()

# Called when the object collides with another area (a different Area2D object)
func _on_area_entered(area: Area2D) -> void:
	# If the object that was entered is an instance of the "Enemy" class
	if area is Enemy:
		# Call the die() method of the "Enemy" object, causing it to "die"
		area.die()
		# removes itself by calling queue_free().
		queue_free()
