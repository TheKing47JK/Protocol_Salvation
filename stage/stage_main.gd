extends Node

func _on_btn_quit_pressed() -> void:
	$AnimationPlayer.play("menu")
	await $AnimationPlayer.animation_finished
	get_tree().quit()

func _on_btn_start_pressed() -> void:
	$AnimationPlayer.play("menu")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file("res://stage/stage1.tscn")
