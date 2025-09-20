extends AnimatedSprite2D

func _ready():
	# Play the "explode" animation immediately when the node is ready
	play("explode")
	# Play the explosion sound effect
	$AudioStreamPlayer2D.play()
	# Connect the "animation_finished" signal to handle cleanup
	connect("animation_finished", Callable(self, "_on_explosion_finished"))

func _on_explosion_finished():
	# When the explosion animation is done, remove this node from the scene tree
	queue_free()
	#get_tree().change_scene_to_file("res://scenes/GameOver.tscn")
