extends AnimatedSprite2D

func _ready():
	play("explosion")
	$AudioStreamPlayer2D.play()

	# Play spark particles
	$Sparks.restart()
	$Sparks.emitting = true

	connect("animation_finished", Callable(self, "_on_finished"))

	var cam = get_tree().get_first_node_in_group("main_camera")
	if cam:
		cam.shake(6)

func _on_finished():
	queue_free()
