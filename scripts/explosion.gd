extends AnimatedSprite2D

func _ready():
	play("explosion")
	
	if randf() < 0.001:
		$willhelm_screem.play()
	else:
		$explosion.play()

	connect("animation_finished", Callable(self, "_on_animation_finished"))

	var cam = get_tree().get_first_node_in_group("main_camera")
	if cam:
		cam.shake(6)

func _on_animation_finished():
	# Instead of freeing immediately, wait for sound to finish
	var active_sound: AudioStreamPlayer2D = null
	if $willhelm_screem.playing:
		active_sound = $willhelm_screem
	elif $explosion.playing:
		active_sound = $explosion

	if active_sound:
		await active_sound.finished  # Wait until sound done
	queue_free()
