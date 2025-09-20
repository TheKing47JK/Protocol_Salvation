extends AnimatedSprite2D

func _ready():
	# Play the explosion sound effect when the node is created
	$AudioStreamPlayer2D.play()
	# Start the "explosion" animation
	play("explosion")
	# Connect the animation_finished signal to a cleanup function
	connect("animation_finished", Callable(self, "_on_finished"))

func _on_finished():
	queue_free()
