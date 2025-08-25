extends Node

var score: int = 0
var high_score: int = 0

func add_points(points: int) -> void:
	score += points
	if score > high_score:
		high_score = score

func reset_score() -> void:
	score = 0
