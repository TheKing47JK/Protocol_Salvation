extends Area2D

@export var speed = 1000

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Update the vertical position of the object by increasing it based on the speed 
	# (moving downwards because is for enemy)
	global_position.y += speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body is ShipPlayer:
		body.die()
		queue_free()
