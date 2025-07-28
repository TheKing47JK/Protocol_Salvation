extends Control

var parmor_icon := preload("res://HUD/armor_icon.tscn")

@onready var armor_container := $armor_container

func _ready():
	clear_armor()
	Signals.connect("on_player_armor_changed", _on_player_armor_changed)

func clear_armor():
	for child in armor_container.get_children():
		child.queue_free()

func set_armor(armors: int):
	clear_armor()
	for i in range(armors):
		var icon = parmor_icon.instantiate()
		armor_container.add_child(icon)

func _on_player_armor_changed(armor: int):
	set_armor(armor)
