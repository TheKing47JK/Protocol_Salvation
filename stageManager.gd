extends Node

# List of stage scene paths in order
var stages = [
	"res://stage/stage1.tscn",
	"res://stage/stage2.tscn",
	"res://stage/stage3.tscn"
]

# Keeps track of the currently loaded stage index
var current_stage_index = 0

# Load a stage by its index from the stages array
func load_stage(index: int):
	if index < stages.size():
		current_stage_index = index
		# Use the TransitionManager to switch scenes with a fade effect
		TransitionManager.transition_to(stages[index], 1.0)
	else:
		# If there are no more stages, go to the Win scene
		TransitionManager.transition_to("res://scenes/WinScene.tscn", 1.0)
		
func load_clear_scene():
	TransitionManager.transition_to("res://scenes/StageClear.tscn", 1.0)

# Load the next stage in sequence
func next_stage():
	load_stage(current_stage_index + 1)
