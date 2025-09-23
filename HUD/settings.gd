extends Control

var master_bus_id: int
var music_bus_id: int

func _ready() -> void:
	master_bus_id = AudioServer.get_bus_index("Master")
	music_bus_id = AudioServer.get_bus_index("Music")

	# Get the current bus volumes (in dB) and convert them back to linear for the slider
	var master_db = AudioServer.get_bus_volume_db(master_bus_id)
	var music_db = AudioServer.get_bus_volume_db(music_bus_id)

	$setting_panel/control/Master.value = db_to_linear(master_db)
	$setting_panel/control/Music.value = db_to_linear(music_db)

	# (Optional) Apply these values to the buses in case sliders were saved differently
	AudioServer.set_bus_volume_db(master_bus_id, linear_to_db($setting_panel/control/Master.value))
	AudioServer.set_bus_volume_db(music_bus_id, linear_to_db($setting_panel/control/Music.value))


func _on_mute_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(master_bus_id, toggled_on)


func _on_master_value_changed(value: float) -> void:
	var db = linear_to_db(value)
	AudioServer.set_bus_volume_db(master_bus_id, db)


func _on_music_value_changed(value: float) -> void:
	var db = linear_to_db(value)
	AudioServer.set_bus_volume_db(music_bus_id, db)


func _on_btn_confirm_pressed() -> void:
	var master_value = $setting_panel/control/Master.value
	var music_value = $setting_panel/control/Music.value
	
	AudioServer.set_bus_volume_db(master_bus_id, linear_to_db(master_value))
	AudioServer.set_bus_volume_db(music_bus_id, linear_to_db(music_value))
	
	TransitionManager.transition_to("res://stage/stage_main.tscn")
