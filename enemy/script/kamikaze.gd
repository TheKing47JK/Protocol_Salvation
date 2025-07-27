extends enemy

@export var PlayerInArea : player = null

func _process(delta):
	if PlayerInArea != null:
		PlayerInArea.damage(1)
	pass

func _on_area_entered(area: Area2D) -> void:
	if area is player:
		PlayerInArea = area
	pass # Replace with function body.

func _on_area_exited(area: Area2D) -> void:
	if area is player:
		PlayerInArea = null
	pass # Replace wwwith function body.
