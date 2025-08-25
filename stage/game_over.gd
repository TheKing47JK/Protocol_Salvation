extends Panel

@onready var score_label = $Panel/Score
@onready var high_score_label = $Panel/HighSore
@onready var btn_retry = $Panel/btn_restart
@onready var btn_quit = $Panel/btn_menu

func _ready() -> void:
	# Load saved high score
	var high_score = get_high_score()
	var score = ScoreManager.score

	# Update labels
	score_label.text = "Score: %d" % score
	high_score_label.text = "High Score: %d" % high_score

	# Update high score if beaten
	if score > high_score:
		save_high_score(score)
		high_score_label.text = "High Score: %d" % score

	# Button signals
	btn_retry.pressed.connect(_on_retry_pressed)
	btn_quit.pressed.connect(_on_quit_pressed)

func _on_retry_pressed() -> void:
	get_tree().change_scene_to_file("res://stage/stage1.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()

# Save/load high score
func get_high_score() -> int:
	if FileAccess.file_exists("user://high_score.save"):
		var file = FileAccess.open("user://high_score.save", FileAccess.READ)
		return file.get_32()
	return 0

func save_high_score(score: int) -> void:
	var file = FileAccess.open("user://high_score.save", FileAccess.WRITE)
	file.store_32(score)
