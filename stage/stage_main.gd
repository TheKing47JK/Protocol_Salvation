extends Control
@onready var control: CanvasLayer = $control

func _ready() -> void:
	$control/btn_start.pressed.connect(_on_start_pressed)
	$control/btn_options.pressed.connect(_on_options_pressed)
	$control/btn_quit.pressed.connect(_on_quit_pressed)

func _on_start_pressed() -> void:
	TransitionManager.transition_to("res://stage/stage1.tscn")

func _on_options_pressed() -> void:
	pass
	


func _on_quit_pressed() -> void:
	get_tree().quit()
