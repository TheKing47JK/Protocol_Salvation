extends Control

func _ready() -> void:
	$AnimationPlayer.play("RESET")

func resume():
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")
	
func pause():
	get_tree().paused = true
	$AnimationPlayer.play("blur")

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("esc") and !get_tree().paused :
		pause()
	elif Input.is_action_just_pressed("esc") and get_tree().paused :
		resume()


func _on_btn_resume_pressed() -> void:
	resume()

func _on_btn_restart_pressed() -> void:
	resume()
	get_tree().reload_current_scene()


func _on_btn_menu_pressed() -> void:
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")
	TransitionManager.transition_to("res://stage/stage_main.tscn")
