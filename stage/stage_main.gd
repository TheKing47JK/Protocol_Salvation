extends Node


var secret_code = [KEY_UP, KEY_UP, KEY_DOWN, KEY_DOWN,KEY_LEFT, KEY_RIGHT, KEY_LEFT, KEY_RIGHT,KEY_B, KEY_A]

var input_history: Array = []
@onready var secret_sound: AudioStreamPlayer2D = $secret_sound  

func _ready() -> void:
	set_process_input(true)

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		# Record key
		input_history.append(event.keycode)

		if input_history.size() > secret_code.size():
			input_history.pop_front()
		
		if input_history == secret_code:
			_trigger_easter_egg()


func _trigger_easter_egg() -> void:
	if secret_sound:
		secret_sound.play()
	print("✨ Secret Code activated!")

func _on_btn_quit_pressed() -> void:
	$AnimationPlayer.play("menu")
	await $AnimationPlayer.animation_finished
	get_tree().quit()

func _on_btn_start_pressed() -> void:
	$AnimationPlayer.play("menu")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file("res://stage/stage1.tscn")
