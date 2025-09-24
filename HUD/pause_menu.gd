extends Control

func _ready() -> void:
	$AnimationPlayer.play("RESET")
	hide_menu() # make sure it's disabled at start

func resume():
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")
	hide_menu()  # disable clicks

func pause():
	get_tree().paused = true
	$AnimationPlayer.play("blur")
	show_menu()  # enable clicks

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("esc"):
		if get_tree().paused:
			resume()
		else:
			pause()

func _on_btn_resume_pressed() -> void:
	resume()

func _on_btn_restart_pressed() -> void:
	resume()
	get_tree().reload_current_scene()

func _on_btn_menu_pressed() -> void:
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")
	hide_menu()
	TransitionManager.transition_to("res://stage/stage_main.tscn")


func show_menu():
	self.visible = true
	self.mouse_filter = Control.MOUSE_FILTER_STOP  # capture input

func hide_menu():
	self.visible = false
	self.mouse_filter = Control.MOUSE_FILTER_IGNORE # ignore input
