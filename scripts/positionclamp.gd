class_name PositionClamp
extends Node

@export var actor: Node2D
@export var margin: int = 15

var left_border = 0
var right_border = ProjectSettings.get_setting("display/window/size/viewport_width")

func _process(_delta: float) -> void:
	actor.global_position.x = clamp(actor.global_position.x, left_border + margin, right_border-margin)
