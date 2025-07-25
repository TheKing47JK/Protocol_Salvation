class_name MoveInput
extends Node

@export var move_stats: MoveStats
@export var move_component: Move

func _input(_event: InputEvent) -> void:
	var input_axis = Input.get_axis("ui_left", "ui_right")
	move_component.velocity = Vector2(input_axis * move_stats.speed, 0)
