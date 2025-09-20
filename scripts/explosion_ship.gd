extends AnimatedSprite2D

func _ready():
	play("explode")
	$AudioStreamPlayer2D.play()

	# Play spark particles
	if has_node("Sparks"):
		$Sparks.restart()
		$Sparks.emitting = true

	connect("animation_finished", Callable(self, "_on_explosion_finished"))

	# When the player explodes, the screen shakes violently
	var cam = get_tree().get_first_node_in_group("main_camera")
	if cam:
		cam.shake(12)

func _on_explosion_finished():
	queue_free()
