extends AnimatedSprite2D

func _ready():
	play("explode")
	if randf() < 0.01:
		$willhelm_screem.play()
	else:
		$explosion.play()
	connect("animation_finished", Callable(self, "_on_explosion_finished"))

	# When the player explodes, the screen shakes violently
	var cam = get_tree().get_first_node_in_group("main_camera")
	if cam:
		cam.shake(12)

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
