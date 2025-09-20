extends Control

var master_bus_id: int
var music_bus_id: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	master_bus_id = AudioServer.get_bus_index("Master")
	music_bus_id = AudioServer.get_bus_index("Music")
	pass # Replace with function body.

func _on_mute_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(0,toggled_on)
	pass # Replace with function body.

func _on_master_value_changed(value: float) -> void:
	var db = linear_to_db(value)
	AudioServer.set_bus_volume_db(master_bus_id, db)
	pass # Replace with function body.


func _on_music_value_changed(value: float) -> void:
	var db = linear_to_db(value)
	AudioServer.set_bus_volume_db(music_bus_id, db)
	pass # Replace with function body.


func _on_btn_confirm_pressed() -> void:
	var master_value = $setting_panel/control/Master.value
	var music_value = $setting_panel/control/Music.value
	
	AudioServer.set_bus_volume_db(master_bus_id, linear_to_db(master_value))
	AudioServer.set_bus_volume_db(music_bus_id, linear_to_db(music_value))
	
	TransitionManager.transition_to("res://stage/stage_main.tscn")

	pass # Replace with function body.
