extends AnimatedSprite2D

func _ready():
	play("explosionminiboss")
	if has_node("Sparks"):
		$Sparks.restart()
		$Sparks.emitting = true
		
	if randf() < 0.001:
		$willhelm_screem.play()
	else:
		$explosion.play()
	connect("animation_finished", Callable(self, "_on_animation_finished"))
	var cam = get_tree().get_first_node_in_group("main_camera")
	if cam:
		cam.shake(12)

func _on_animation_finished():
	queue_free()
