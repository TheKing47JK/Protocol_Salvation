extends Node

var lvl1_completed = false
var lvl2_completed = false
var lvl3_completed = false

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
		if index == 1:
			lvl1_completed = true
		if index == 2:
			lvl2_completed = true
		TransitionManager.transition_to(stages[index], 1.0)
	else:
		# If there are no more stages, go to the Win scene
		lvl3_completed = true
		TransitionManager.transition_to("res://scenes/WinScene.tscn", 1.0)
			
func load_clear_scene():
	if current_stage_index == 0:
		lvl1_completed = true
	if current_stage_index == 1:
		lvl2_completed = true
	TransitionManager.transition_to("res://scenes/StageClear.tscn", 1.0)

# Load the next stage in sequence
func next_stage():
	load_stage(current_stage_index + 1)
